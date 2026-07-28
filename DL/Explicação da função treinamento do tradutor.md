Analisei o notebook “Trabalho de DL - Tradutor (Transformer) - G13 V03(2).ipynb” e a função responsável pelo treinamento é esta: def train_epoch(model, dataloader, optimizer, criterion, device, epoch):. Ela aparece na célula 74 do notebook. train_epoch() significa literalmente “treinar uma época” (epoch).

Vou explicar como ela funciona para um leigo, usando a analogia de um professor corrigindo exercícios de tradução.

### O que é uma “epoch”?

Imagine que você tem 1.000 frases em português e suas respectivas traduções em inglês.

Uma epoch é quando o modelo vê todas essas frases uma vez.

A função `train_epoch()` faz exatamente isso:

Recebe um lote de frases

Pega um pequeno conjunto de frases do `dataloader`.

Pede uma tradução

Executa o Transformer para gerar previsões.

Compara com a resposta correta

Calcula o erro usando a função de perda (`criterion`).

Ajusta o modelo

Atualiza os pesos para tentar errar menos na próxima vez.

Repete até terminar o conjunto inteiro

Quando todas as frases forem processadas, a época termina e a função devolve a perda média.

### Explicando linha por linha

### 1. Preparação do treino

Python

```
start = time.time()
model.train()

total_loss = 0.0
```

* `time.time()` começa a contar o tempo.

* `model.train()` coloca o Transformer em modo de treinamento.

* `total_loss` vai acumular os erros de todos os lotes.

### 2. Percorrendo os lotes de dados

Python

```
for batch_num, (src, tgt) in enumerate(tqdm(dataloader, desc=f'Epoch {epoch+1}')):
```

Aqui o `dataloader` entrega vários mini-lotes (batches).

* `src` = frases de entrada (português).

* `tgt` = traduções corretas (inglês).

Exemplo simplificado:

```
src: "eu gosto de café"
tgt: "i like coffee"
```

O `tqdm` apenas mostra uma barra de progresso.

### 3. Enviando para CPU ou GPU

Python

```
src = src.to(device)
tgt = tgt.to(device)
```

Se você estiver usando GPU, os dados são copiados para ela para acelerar o treinamento.

### 4. Criando a entrada do decodificador

Este é o trecho mais importante:

Python

```
tgt_input = torch.full(
    (tgt.size(0), tgt.size(1)),
    pad_id,
    device=tgt.device
)
tgt_input[:,1:] = tgt[:, :-1]
```

### O que isso faz?

O Transformer tradutor funciona como alguém que escreve uma palavra por vez.

Suponha que a resposta correta seja:

```
<bos> i like coffee <eos>
```

O modelo recebe como entrada:

```
[PAD, <bos>, i, like, coffee]
```

e deve prever:

```
[<bos>, i, like, coffee, <eos>]
```

Ou seja, ele aprende a prever o próximo token.

Visualmente:

Resposta correta (`tgt`)

```
<bos>   eu   gosto   de   café   <eos>
```

Entrada usada para treinar (`tgt_input`)

```
PAD   <bos>   eu   gosto   de   café
```

O modelo olha para a sequência deslocada e tenta adivinhar o próximo token em cada posição.

Isso é chamado de teacher forcing.

### 5. Definindo a saída esperada

Python

```
tgt_output = tgt
```

A saída esperada é simplesmente a frase correta completa.

### 6. Criando as máscaras

### Máscara de padding

Python

```
src_mask = create_padding_mask(src).to(device)
```

No notebook, essa função é:

Python

```
def create_padding_mask(seq, pad_idx=pad_id):
    return (seq != pad_idx).unsqueeze(1).unsqueeze(2)
```

Ela marca quais posições são texto real e quais são apenas PAD.

Exemplo:

```
[eu, gosto, de, café, PAD, PAD]
 ↓
[ 1,    1,    1,   1,   0,   0 ]
```

Assim o modelo ignora os espaços vazios.

### Máscara causal

Python

```
tgt_mask = (
    create_padding_mask(tgt_input)
    &
    create_causal_mask(tgt_input.size(1)).to(device)
)
```

A `create_causal_mask()` usa `torch.tril(...)`, produzindo algo assim:

```
1 0 0 0
1 1 0 0
1 1 1 0
1 1 1 1
```

Isso impede que o modelo veja palavras futuras durante o treinamento.

### 7. Zerando gradientes

Python

```
optimizer.zero_grad()
```

Os gradientes são como anotações de correção.

Antes de corrigir um novo lote, apagamos as anotações antigas.

### 8. Executando o Transformer

Python

```
output = model(
    src,
    tgt_input,
    src_mask,
    tgt_mask
)
```

Aqui acontece a tradução prevista.

O modelo recebe:

Encoder

Lê a frase em português (`src`) e cria uma representação interna do significado.

Decoder

Usa `tgt_input` para prever qual deve ser o próximo token em inglês em cada posição da frase.

O resultado `output` contém, para cada posição da frase, uma lista de probabilidades para todo o vocabulário.

### 9. Calculando o erro

Python

```
loss = criterion(
    output.reshape(-1, output.size(-1)),
    tgt_output.reshape(-1)
)
```

O `criterion` normalmente é CrossEntropyLoss.

Ele compara:

* o que o modelo previu

* o token correto

Quanto maior a diferença, maior o `loss`.

Exemplo:

| Posição | Correto |
| ------- | ------- |
| 1       | i       |
| 2       | like    |
| 3       | coffee  |

Se o modelo disser `"eat"` em vez de `"like"`, ele recebe uma penalidade.

### 10. Retropropagação

Python

```
loss.backward()
```

Essa é a etapa em que o modelo descobre quais pesos causaram o erro.

Analogia:

“Você errou a tradução porque prestou atenção demais na palavra X e de menos na palavra Y.”

O PyTorch calcula automaticamente essas correções usando backpropagation.

### 11. Limitando gradientes

Python

```
torch.nn.utils.clip_grad_norm_(
    model.parameters(),
    max_norm=1.0
)
```

Isso evita que as correções fiquem grandes demais.

Sem isso, o treinamento pode ficar instável e “explodir”.

Pense como um professor dizendo:

“Corrija, mas não mude tudo de uma vez.”

### 12. Atualizando os pesos

Python

```
optimizer.step()
```

Agora o otimizador (Adam, provavelmente) altera os pesos da rede.

É aqui que o modelo realmente aprende.

### 13. Acumulando a perda

Python

```
total_loss += loss.item()
```

Guarda o erro desse lote para calcular a média no final.

### 14. Liberando memória

Python

```
del output
gc.collect()
torch.cuda.empty_cache()
```

Seu notebook faz uma limpeza explícita da memória da GPU ao final da época.

Isso é útil em máquinas com pouca VRAM (como você comentou em conversas anteriores).

### 15. Resultado final

Python

```
return total_loss / len(dataloader)
```

A função devolve:

* perda média da época

* um número como `1.85`, `0.92`, `0.41`…

Quanto menor, melhor o tradutor está ficando.

### Fluxo completo para um leigo

Pega frases em português

Mostra um pedaço da tradução correta

O Transformer tenta completar a tradução

Compara com a tradução verdadeira

Calcula o erro

Ajusta os pesos internos

Repete para todos os lotes

Retorna o erro médio da época

### Em uma única frase

A função `train_epoch()` ensina o Transformer a traduzir repetindo milhares de vezes o ciclo:

“veja a frase → tente traduzir → compare com a resposta correta → descubra o erro → ajuste seus parâmetros para errar menos na próxima tentativa.”

Esse é o coração do aprendizado supervisionado do seu tradutor baseado no artigo “Attention Is All You Need”.
