Sim. Essa é uma forma muito comum de organizar projetos no Google Colab: você mantém uma pasta compartilhada no Google Drive com os dados comuns e cria dois (ou mais) notebooks Colab independentes que acessam essa mesma pasta.

O ponto importante é distinguir o notebook do armazenamento:

* Notebook (.ipynb) → pode ficar em qualquer lugar do Drive.

* Dados → ficam em uma pasta compartilhada do Drive (Minha unidade ou Drive compartilhado).

### Estrutura recomendada

No Google Drive:

```
MeuDrive/
└── ProjetoML/
    ├── dados/
    │   ├── treino.csv
    │   ├── teste.csv
    │   └── imagens/
    ├── notebook_preprocessamento.ipynb
    └── notebook_modelo.ipynb
```

Os dois notebooks acessam `ProjetoML/dados`.

### Em cada notebook Colab

Monte o Drive:

Python

```
from google.colab import drive
drive.mount('/content/drive')
```

Depois use o mesmo caminho:

Python

```
BASE = '/content/drive/MyDrive/ProjetoML/dados'

import pandas as pd

df_treino = pd.read_csv(f'{BASE}/treino.csv')
df_teste  = pd.read_csv(f'{BASE}/teste.csv')
```

### Se a pasta for compartilhada por outra pessoa

Quando alguém compartilha uma pasta com você, ela aparece em “Compartilhados comigo”, mas o caminho direto no Colab pode ser inconveniente.

O ideal é:

* No Drive, abra Compartilhados comigo.

* Clique com o botão direito na pasta → Adicionar atalho ao Drive.

* Escolha Minha unidade.

Então o caminho ficará algo como:

Python

```
BASE = '/content/drive/MyDrive/ProjetoCompartilhado/dados'
```

### Dois notebooks podem usar os mesmos dados ao mesmo tempo?

Sim. Ambos podem:

* ler os mesmos arquivos;

* processar os dados simultaneamente;

* salvar resultados na mesma pasta.

Exemplo:

Python

```
RESULTADOS = '/content/drive/MyDrive/ProjetoML/resultados'

df_saida.to_csv(f'{RESULTADOS}/predicoes.csv', index=False)
```

### Atenção a concorrência de escrita

Se os dois notebooks escreverem no mesmo arquivo ao mesmo tempo, um pode sobrescrever o outro.

Prefira:

Python

```
from datetime import datetime

nome = datetime.now().strftime('%Y%m%d_%H%M%S')
df_saida.to_csv(f'{RESULTADOS}/predicoes_{nome}.csv', index=False)
```

### Usando Drive Compartilhado (Google Workspace)

Se você estiver em uma organização com Drives compartilhados, o caminho muda um pouco:

Python

```
BASE = '/content/drive/Shareddrives/NomeDoDrive/ProjetoML/dados'
```

### Para o seu caso

Como você está trabalhando com datasets para modelos de machine learning / transformer, eu faria assim:

```
ProjetoTransformer/
├── dados_brutos/
├── dados_processados/
├── checkpoints/
├── notebook_preparo.ipynb
└── notebook_treinamento.ipynb
```

* notebook_preparo.ipynb → tokenização, vocabulário, geração dos tensores.

* notebook_treinamento.ipynb → lê os dados processados e treina o modelo.

* checkpoints/ → pesos `.pt` compartilhados entre notebooks.

Isso permite, por exemplo, executar o pré-processamento uma única vez e reutilizar os mesmos arquivos em quantos notebooks Colab você quiser.
