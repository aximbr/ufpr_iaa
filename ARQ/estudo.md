O UCI Adult Dataset é um dataset clássico de classificação binária com vários desafios reais:

* categóricas de média/alta cardinalidade
* missing values mascarados
* desbalanceamento moderado
* correlação entre features
* proxies sensíveis (sexo, raça, país)
* mistura de distribuições lineares e não lineares

A melhor abordagem depende do objetivo:

* benchmark acadêmico
* interpretabilidade
* fairness
* máxima performance
* inferência estatística

Vou focar na abordagem moderna e robusta para ML tabular.

---

# 1. Entender o problema

Target:

```text
income >50K
```

Classificação binária.

---

# 2. Primeiro passo: auditoria das variáveis

Separar:

## Numéricas

* age
* fnlwgt
* education-num
* capital-gain
* capital-loss
* hours-per-week

## Categóricas

* workclass
* education
* marital-status
* occupation
* relationship
* race
* sex
* native-country

---

# 3. Tratar missing values corretamente

O Adult usa:

```text
?
```

como missing.

Primeiro:

```python
df = df.replace("?", np.nan)
```

---

# 4. Análise exploratória ideal

## Para numéricas

Analise:

* distribuição
* skewness
* outliers
* sparsidade

Especialmente:

* capital-gain
* capital-loss

são extremamente esparsas e assimétricas.

---

# 5. Melhor transformação para capital-gain/loss

Essas variáveis têm:

* muitos zeros
* poucos valores enormes

Transformação ideal:

x' = \log(1+x)

Exemplo:

```python
df["capital_gain_log"] = np.log1p(df["capital-gain"])
```

---

# 6. Não usar fnlwgt diretamente (na maioria dos casos)

`fnlwgt`:

* peso censitário
* frequentemente pouco útil preditivamente

Na prática:

* muitos trabalhos removem

Minha recomendação:

* testar com e sem

Frequentemente:

* importância baixa
* pode adicionar ruído

---

# 7. Education vs education-num

Há redundância:

```text
education
education-num
```

Porque:

* `education-num` é codificação ordinal de `education`

Evite usar ambos simultaneamente em modelos lineares.

---

# Melhor prática

## Para árvores

Pode manter ambos.

## Para modelos lineares

Escolha um.

Normalmente:

* `education-num` funciona melhor.

---

# 8. Tratamento ideal das categóricas

## Melhor abordagem moderna

### CatBoost

NÃO faça:

* one-hot encoding
* label encoding manual

Passe categóricas diretamente.

---

# Se usar modelos tradicionais

## Baixa cardinalidade

Use:

* one-hot encoding

---

## Média/alta cardinalidade

`native-country` pode gerar sparsidade.

Melhor:

* target encoding
* frequency encoding
* ou agrupar raros

---

# 9. Agrupamento de categorias raras

Excelente prática no Adult.

Exemplo:

```python
freq = df["native-country"].value_counts()

rare = freq[freq < 100].index

df["native-country"] = (
    df["native-country"]
    .replace(rare, "Other")
)
```

Isso:

* reduz overfitting
* melhora generalização

---

# 10. Escalonamento

## Necessário para:

* SVM
* regressão logística
* KNN

Use:

```python
StandardScaler
```

---

## Não necessário para:

* Random Forest
* XGBoost
* LightGBM
* CatBoost

---

# 11. Análise de importância

Melhor abordagem:

## Gradient boosting + SHAP

Porque:

* captura não linearidade
* mostra interação
* explica categóricas

---

# 12. Variáveis mais importantes no Adult

Quase sempre:

1. marital-status
2. education-num
3. capital-gain
4. age
5. occupation
6. hours-per-week
7. relationship

---

# 13. Fairness e variáveis sensíveis

O Adult é amplamente usado em fairness ML.

Variáveis sensíveis:

* sex
* race
* native-country

Dependendo do objetivo:

* remover
* manter para auditoria
* usar métricas de fairness

---

# 14. Engenharia de features útil

## Interações importantes

Muito úteis:

```text
education × occupation
age × hours-per-week
marital-status × relationship
```

Boosted trees aprendem isso automaticamente.

---

# 15. Melhor pipeline moderno

## Minha recomendação principal

### CatBoost + categóricas nativas

Pipeline:

```text
Missing handling
→ rare category grouping
→ log1p(capital-gain/loss)
→ CatBoost
→ SHAP
```

---

# 16. Pipeline alternativo acadêmico

Se quiser pipeline clássica:

```text
Missing values
→ OneHotEncoder
→ StandardScaler
→ Logistic Regression / SVM
```

---

# 17. Métricas ideais

O Adult é levemente desbalanceado.

Prefira:

* ROC-AUC
* PR-AUC
* F1-score

Evite usar apenas accuracy.

---

# 18. Split correto

Use:

```python
StratifiedKFold
```

porque:

* preserva distribuição da classe

---

# 19. Melhor abordagem para seleção de variáveis

## Recomendada

1. CatBoost
2. SHAP
3. Permutation importance
4. Remover redundâncias

---

# 20. Pipeline ideal completo

## Melhor solução prática hoje

```text
1. Replace ? with NaN
2. Rare category grouping
3. log1p(capital-gain/loss)
4. CatBoost
5. Cross-validation
6. SHAP analysis
7. Fairness audit
```

---

# O que eu NÃO recomendo

## Evitar:

* LabelEncoder em categóricas nominais
* PCA
* remover outliers agressivamente
* normalização para árvores
* one-hot gigantesco para native-country
* usar apenas accuracy

---

# Recomendação final objetiva

## Melhor combinação para Adult:

| Etapa         | Melhor escolha     |
| ------------- | ------------------ |
| categóricas   | CatBoost nativo    |
| missing       | NaN                |
| skewness      | log1p              |
| interpretação | SHAP               |
| validação     | Stratified CV      |
| métrica       | ROC-AUC            |
| importância   | permutation + SHAP |

Essa abordagem costuma produzir:

* melhor generalização
* menor leakage
* melhor interpretabilidade
* menor esforço de feature engineering.
