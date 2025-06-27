# 🍳 Receitas App

Projeto Flutter para gerenciar receitas culinárias. Este aplicativo permite aos usuários visualizar, adicionar, editar, remover e compartilhar suas receitas favoritas. Ele foi desenvolvido como parte de um estudo sobre desenvolvimento de aplicativos móveis com Flutter, focando em gerenciamento de estado, navegação e integração com recursos nativos do dispositivo.

## 📸 Telas (Exemplo)


<p align="center">
  <img src="assets/images/logo.png" width="200" alt="Logo do App">
</p>

## ✨ Funcionalidades

*   **Visualização de Receitas**: Navegue por uma lista completa de receitas.
*   **Detalhes da Receita**: Veja ingredientes, modo de preparo e imagem de cada prato.
*   **Adicionar e Editar**: Crie novas receitas ou modifique as existentes.
*   **Seleção de Imagem**: Adicione fotos às suas receitas usando a câmera ou a galeria do dispositivo.
*   **Favoritos**: Marque suas receitas preferidas para acesso rápido.
*   **Compartilhamento**: Compartilhe facilmente suas receitas com amigos e familiares através de outros aplicativos.
*   **Gestão Local**: Todas as receitas são salvas localmente no dispositivo.

## 🛠️ Tecnologias Utilizadas

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Linguagem**: [Dart](https://dart.dev/)
*   **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider)
*   **Seleção de Imagens**: [image_picker](https://pub.dev/packages/image_picker)
*   **Armazenamento Local**: [path_provider](https://pub.dev/packages/path_provider)
*   **Compartilhamento**: [share_plus](https://pub.dev/packages/share_plus)
*   **Geração de IDs**: [uuid](https://pub.dev/packages/uuid)
*   **Formatação**: [intl](https://pub.dev/packages/intl)

## 🚀 Como Começar

Siga as instruções abaixo para configurar e executar o projeto em sua máquina local.

### Pré-requisitos

*   Ter o SDK do Flutter instalado. Para mais detalhes, consulte a [documentação oficial do Flutter](https://flutter.dev/docs/get-started/install).

### Instalação

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    ```

2.  **Navegue até o diretório do projeto:**
    ```bash
    cd receitas_app
    ```

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

## 📂 Estrutura do Projeto

A estrutura de pastas do projeto segue as convenções da comunidade Flutter:

```
receitas_app/
├── lib/
│   ├── main.dart         # Ponto de entrada da aplicação
│   ├── models/           # Modelos de dados (ex: Recipe)
│   ├── services/         # Lógica de negócios e serviços (ex: RecipeService)
│   ├── screens/          # Widgets que representam as telas da UI
│   └── widgets/          # Widgets reutilizáveis
├── assets/
│   └── images/           # Imagens e outros recursos estáticos
└── pubspec.yaml          # Definições e dependências do projeto
```