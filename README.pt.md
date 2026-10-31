# WebDiet

Aplicativo de Planejamento Alimentar e Saúde.

Projeto responsável pela dieta de pacientes, cálculo de nutrientes, lista de compras, me surpreenda.

O aplicativo possui uma interface moderna, projetada para substituir aplicativos antigos e agradar tanto pacientes quanto nutricionistas. O visual é inspirado pelo [WebDiet](https://webdiet.com.br/site/HOME), utilizando cores clean (como verde menta) e sem bordas pesadas.

O app é extremamente produtivo, já contemplando nativamente todos os recursos solicitados:
* **Cadastro de alimentos**
* **Edição de alimentos**
* **Adição de fotos de alimentos**
* **Catálogo completo de alimentos**

## Funcionalidades Principais

*   **Dieta de Pacientes (MealPage)**:
    *   Planejamento diário (Café da Manhã, Almoço, Jantar).
    *   Visualização de opções de refeições e detalhes (ingredientes, descrição).
    *   Monitoramento de hidratação diária (contador de copos de água).

*   **Cálculo de Nutrientes**:
    *   Cálculo automático de calorias totais do dia.
    *   Barras de progresso para macronutrientes (Proteínas, Carboidratos, Gorduras).
    *   **Calculadora IMC**: Ferramenta dedicada para cálculo do Índice de Massa Corporal (BMI) com categorização de saúde.

*   **Lista de Compras (ShoppingListPage)**:
    *   Geração automática de lista baseada nas refeições do dia.
    *   Agrupamento de ingredientes iguais.
    *   Funcionalidade de marcar itens comprados.
    *   Copiar lista para a área de transferência.

*   **Me Surpreenda (Surprise Me)**:
    *   **Refeições Aleatórias**: Botão "Me Surpreenda" na tela principal que gera um plano alimentar aleatório para o dia.
    *   **Frases Motivacionais**: Exibição de frases inspiradoras via API.
    *   **Receita Surpresa**: Funcionalidade extra para buscar uma receita aleatória de uma API externa (TheMealDB).

## Estrutura do Projeto

*   `lib/pages`: Contém as telas principais (MealPage, ShoppingListPage, BMICalculatorPage, RandomRecipePage).
*   `lib/models`: Modelos de dados (Meal).
*   `lib/data`: Dados estáticos das refeições.
*   `lib/services`: Lógica de comunicação com APIs externas.
*   `lib/utils`: Utilitários (Calculadora de IMC).

## Executando o Projeto

Este projeto utiliza Flutter. Para rodar:

```bash
flutter pub get
flutter run
```

## Deploy

A versão web é publicada no **GitHub Pages** pelo workflow [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml). Cada push na branch padrão (`master`) ou execução manual gera `build/web` e publica em:

```text
https://juninmd.github.io/my-food/
```

Configuração única do repositório (para forks): em **Settings → Pages → Build and deployment**, selecione **Source: GitHub Actions**. Não é necessário Netlify, token ou `netlify.toml`. Pull requests executam o mesmo build sem publicar.

## Testes

O projeto inclui testes unitários e de widget para garantir a integridade das funcionalidades principais.

```bash
flutter test
```
