Suponha que inicialmente eu dividi minha base em treino e teste, com 30% para teste. Essa base usarei para validação cruzada, porém quero usar a mesma base de treino para fazer experimento no modelo usando hold out e depois fazer predição nos modelos usando apenas a base de teste. como fazer?

O fluxo mais correto é:

1. **Separar treino e teste uma única vez** (70% / 30%).
2. **Nunca olhar para o conjunto de teste durante a seleção de hiperparâmetros.**
3. Dentro dos 70% de treino, você pode:

   * fazer validação cruzada; ou
   * fazer hold-out (treino + validação).

Depois de escolher os hiperparâmetros, você treina o modelo final usando todos os 70% de treino e faz uma única avaliação nos 30% de teste.

Exemplo:

```python
from sklearn.model_selection import train_test_split

# Separação inicial
X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.30,
    random_state=42
)
```

Agora você quer fazer um experimento usando hold-out apenas dentro do conjunto de treino:

```python
X_tr, X_val, y_tr, y_val = train_test_split(
    X_train,
    y_train,
    test_size=0.20,
    random_state=42
)
```

Fica assim:

```
Base original
│
├── Treino (70%)
│   ├── Treino interno (56%)
│   └── Validação (14%)
│
└── Teste (30%)
```

Você ajusta os hiperparâmetros usando apenas `X_tr` e `X_val`.

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

model = RandomForestClassifier(
    n_estimators=200,
    max_depth=10
)

model.fit(X_tr, y_tr)

pred_val = model.predict(X_val)

print(accuracy_score(y_val, pred_val))
```

Após decidir quais parâmetros são os melhores, descarte essa divisão interna e treine novamente usando **todo o conjunto de treino (70%)**:

```python
best_model = RandomForestClassifier(
    n_estimators=200,
    max_depth=10
)

best_model.fit(X_train, y_train)
```

Somente então faça a predição no conjunto de teste:

```python
pred_test = best_model.predict(X_test)

print(accuracy_score(y_test, pred_test))
```

---

Se você quiser comparar **hold-out versus validação cruzada**, use exatamente o mesmo conjunto de teste final:

```
Experimento A:
    X_train -> Hold-out
    X_test  -> Avaliação final

Experimento B:
    X_train -> Cross-validation
    X_test  -> Avaliação final
```

Assim os resultados no teste são comparáveis porque ambos os modelos nunca tiveram acesso aos 30% reservados.

Uma observação importante: se você estiver usando `GridSearchCV` em um experimento e hold-out manual em outro, o conjunto de teste deve continuar intocado até o fim. Caso contrário, você estará usando o teste como validação e perderá uma estimativa imparcial do desempenho do modelo.

---
Defina um dicionario (python) que tenha o nome do modelo, o modelo e um flag (CV ou HO).

Você pode organizar isso de várias formas. Uma estrutura simples é um dicionário de dicionários:

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.linear_model import LogisticRegression

modelos = {
    "random_forest_cv": {
        "nome": "Random Forest",
        "modelo": RandomForestClassifier(),
        "estrategia": "CV"
    },

    "svm_holdout": {
        "nome": "SVM",
        "modelo": SVC(),
        "estrategia": "HO"
    },

    "logistic_cv": {
        "nome": "Logistic Regression",
        "modelo": LogisticRegression(),
        "estrategia": "CV"
    }
}
```

Uso:

```python
for chave, info in modelos.items():
    print(info["nome"])
    print(info["modelo"])
    print(info["estrategia"])
```

Saída:

```text
Random Forest
RandomForestClassifier()
CV

SVM
SVC()
HO

Logistic Regression
CV
```

Se você pretende fazer muitos experimentos, uma estrutura mais compacta é:

```python
modelos = {
    "rf": (
        "Random Forest",
        RandomForestClassifier(),
        "CV"
    ),
    "svm": (
        "SVM",
        SVC(),
        "HO"
    ),
    "lr": (
        "Logistic Regression",
        LogisticRegression(),
        "CV"
    )
}
```

ou usando `dataclass`, que costuma ficar mais organizado para pipelines de experimentação:

```python
from dataclasses import dataclass

@dataclass
class ConfigModelo:
    nome: str
    modelo: object
    estrategia: str  # "CV" ou "HO"

modelos = {
    "rf": ConfigModelo(
        nome="Random Forest",
        modelo=RandomForestClassifier(),
        estrategia="CV"
    ),
    "svm": ConfigModelo(
        nome="SVM",
        modelo=SVC(),
        estrategia="HO"
    )
}
```

Para projetos de machine learning maiores, a versão com `dataclass` costuma ser a mais fácil de manter e expandir.
