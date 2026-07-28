Se o seu objetivo é **estudar a implementação de um Transformer em PyTorch**, eu priorizaria os seguintes materiais.

### 1. Tutorial oficial do TensorFlow (Português → Inglês)

É o tutorial que você já vinha utilizando e que pode servir de base para uma conversão para PyTorch.

**Link:**
[Neural machine translation with a Transformer and Keras](https://www.tensorflow.org/tutorials/text/transformer?utm_source=chatgpt.com)

Utiliza o dataset `ted_hrlr_translate/pt_to_en`. ([TensorFlow][1])

---

### 2. Documentação oficial do `torch.nn.Transformer`

Mostra a API da implementação de referência do PyTorch para a arquitetura proposta no artigo original.

**Link:**
[torch.nn.Transformer (PyTorch)](https://docs.pytorch.org/docs/stable/generated/torch.nn.Transformer?utm_source=chatgpt.com)

É uma boa referência para entender os parâmetros da classe e sua utilização. ([PyTorch Documentation][2])

---

### 3. Tutorial oficial de tradução com TorchText

Ensina a construir um sistema de tradução usando `torchtext`, incluindo tokenização, vocabulário, `DataLoader` e treinamento de um modelo seq2seq com atenção.

**Link:**
[Language Translation with TorchText](https://docs.pytorch.org/tutorials/beginner/torchtext_translation_tutorial.html?utm_source=chatgpt.com)

Embora utilize um modelo com atenção (e não exatamente um Transformer completo), é excelente para entender o pipeline de tradução em PyTorch. ([PyTorch Documentation][3])

---

### 4. The Annotated Transformer (Harvard NLP)

Provavelmente o melhor material disponível para compreender o artigo *Attention Is All You Need*.

**Link:**
[The Annotated Transformer](https://nlp.seas.harvard.edu/annotated-transformer/?trk=public_post_comment-text&utm_source=chatgpt.com)

O material apresenta uma implementação comentada, praticamente linha por linha, do Transformer original em PyTorch. ([Harvard NLP][4])

---

### 5. Hugging Face – Translation

Mostra como treinar e fazer fine-tuning de modelos Transformer para tradução.

**Link:**
[Hugging Face – Translation Task Guide](https://huggingface.co/docs/transformers/main/tasks/translation?utm_source=chatgpt.com)

É mais voltado para uso de modelos prontos e fine-tuning do que para implementação do zero. ([Hugging Face][5])

---

### 6. PyTorch Hub (Fairseq)

Exemplo de utilização de modelos Transformer já treinados para tradução.

**Link:**
[PyTorch Hub – Transformer (NMT)](https://pytorch.org/hub/pytorch_fairseq_translation/?utm_source=chatgpt.com)

Permite carregar modelos pré-treinados (por exemplo, inglês↔francês e inglês↔alemão) com poucas linhas de código. ([PyTorch][6])

---

### 7. Artigo original

O artigo que introduziu a arquitetura Transformer.

**Link:**
[Attention Is All You Need (arXiv)](https://arxiv.org/abs/1706.03762?utm_source=chatgpt.com)

Continua sendo a principal referência para entender os fundamentos da arquitetura. ([arXiv][7])

---

## Minha recomendação para o seu caso

Considerando que você está estudando a implementação do tutorial de tradução **Português → Inglês** e já trabalhou com o dataset `ted_hrlr_translate/pt_to_en`, eu seguiria esta sequência:

1. **Tutorial do TensorFlow** (entender a arquitetura e o fluxo completo).
2. **The Annotated Transformer** (entender cada componente do Transformer em PyTorch).
3. **Documentação do `torch.nn.Transformer`** (conhecer a API oficial).
4. **Implementar o tutorial do TensorFlow em PyTorch** utilizando `torch.nn.Transformer`.
5. **Comparar com a implementação do Hugging Face**, apenas para verificar diferenças de engenharia e desempenho.

Essa sequência permite compreender a teoria, a implementação de baixo nível e, por fim, as práticas adotadas em bibliotecas de produção.

[1]: https://www.tensorflow.org/tutorials/text/transformer?utm_source=chatgpt.com "Neural machine translation with a Transformer and Keras  |  Text  |  TensorFlow"
[2]: https://docs.pytorch.org/docs/stable/generated/torch.nn.Transformer?utm_source=chatgpt.com "Transformer — PyTorch 2.11 documentation"
[3]: https://docs.pytorch.org/tutorials/beginner/torchtext_translation_tutorial.html?utm_source=chatgpt.com "Language Translation with TorchText — PyTorch Tutorials 1.7.1 documentation"
[4]: https://nlp.seas.harvard.edu/annotated-transformer/?trk=public_post_comment-text&utm_source=chatgpt.com "The Annotated Transformer"
[5]: https://huggingface.co/docs/transformers/main/tasks/translation?utm_source=chatgpt.com "Translation · Hugging Face"
[6]: https://pytorch.org/hub/pytorch_fairseq_translation/?utm_source=chatgpt.com "Transformer (NMT) – PyTorch"
[7]: https://arxiv.org/abs/1706.03762?utm_source=chatgpt.com "Attention Is All You Need"
