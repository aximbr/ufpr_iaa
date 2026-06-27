Você pode representar o fluxo de dados desse processo da seguinte forma:

```text
┌─────────────────────┐
│      padroes        │
│ (dados originais)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ np.array(padroes)   │
│      → vet          │
└──────────┬──────────┘
           │
           ├────────────────────────┐
           │                        │
           ▼                        ▼
┌─────────────────┐       ┌────────────────────┐
│ caracteristicas │       │      classes       │
│ vet[:,0:-1]     │       │ vet[:,-1]          │
│ (Features X)    │       │ (Labels y)         │
└────────┬────────┘       └─────────┬──────────┘
         │                          │
         └────────────┬─────────────┘
                      ▼
         ┌─────────────────────────┐
         │ train_test_split()      │
         │ test_size = 30%         │
         │ stratify = classes      │
         └───────────┬─────────────┘
                     │
       ┌─────────────┴─────────────┐
       ▼                           ▼
┌─────────────────┐     ┌─────────────────┐
│ X_train,y_train │     │ X_test,y_test   │
│     (70%)       │     │      (30%)      │
└────────┬────────┘     └─────────────────┘
         │
         ▼
┌──────────────────────────────┐
│ GridSearchCV                 │
│ scoring = f1_macro           │
│ cv = StratifiedKFold(5)      │
└──────────────┬───────────────┘
               │
               ▼
      ┌──────────────────┐
      │ Validação Cruzada│
      │ Estratificada 5x │
      └────────┬─────────┘
               │
      ┌────────┴─────────┐
      │ Para cada fold   │
      ▼                  │
┌───────────────────────┐│
│ Pipeline              ││
│                       ││
│ MinMaxScaler          ││
│        ↓              ││
│ SVM (SVC)             ││
└──────────┬────────────┘│
           │             │
           ▼             │
┌───────────────────────┐│
│ Teste de combinações  ││
│ de hiperparâmetros    ││
│                       ││
│ kernel                ││
│ C                     ││
│ gamma                 ││
│ class_weight          ││
└──────────┬────────────┘│
           │             │
           └─────────────┘
               │
               ▼
┌─────────────────────────────┐
│ Seleção do melhor modelo    │
│ (maior F1 Macro médio)      │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ buscador_grid.fit()         │
│ Modelo final treinado       │
│ usando X_train e y_train    │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ Melhor SVM encontrado       │
│ (best_estimator_)           │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────┐
│ Avaliação futura em         │
│ X_test e y_test             │
│ (conjunto nunca visto)      │
└─────────────────────────────┘
```

### Resumo do fluxo

1. **Dados brutos (`padroes`)** → convertidos para `numpy`.
2. Separação em:

   * **Características (X)**.
   * **Classes (y)**.
3. **Train/Test Split** (70% treino, 30% teste), preservando a proporção das classes.
4. Apenas o conjunto de **treino** entra no **GridSearchCV**.
5. O GridSearchCV executa uma **validação cruzada estratificada de 5 folds**.
6. Em cada fold:

   * Aplica **MinMaxScaler** nos dados de treino.
   * Treina uma **SVM**.
   * Testa diferentes combinações de hiperparâmetros.
7. Seleciona a combinação com maior **F1 Macro**.
8. Reajusta o melhor modelo usando todo o conjunto de treino (`X_train`, `y_train`).
9. O modelo final pode então ser avaliado em `X_test` e `y_test`, que permaneceram isolados durante toda a busca de hiperparâmetros.

Uma representação mais adequada para documentação técnica ou artigo seria um diagrama BPMN/UML de fluxo de dados com os blocos **Dados → Split → GridSearchCV → Cross Validation → Pipeline (Scaler + SVM) → Melhor Modelo → Teste Final**.
