## O que é um Dicionário de Dados (DD)? ##
O DD é uma listagem organizada de todos os elementos de dados pertinentes ao sistema, com
definições precisas e rigorosas para que se possa conhecer todas as entradas, saídas, componentes
de depósitos e cálculos intermediários.

## Criando um dicionário de dados no MySQL Workbench ##
Para criar um dicionário de dados no MySQL Workbench a partir do modelo MRN você terá que fazer o download do plugin [DBdoc](https://github.com/luizventurote/banco-de-dados-II/blob/master/dicionario-de-dados/plugin/dbdoc_plugin.lua).

- Após ter feito o download abra o diagrama MRN no MySQL Workbench;
- Vá em: `Scripting` > `Install/Plugin Mode`;
- Aponte para o local onde foi salvo o plugin (na caixa de seleção de arquivo mude para a extensão lua files);
- Após ter instalado o plugin reinicie o Workench;
- Para gerar o dicionário acesse: `Tools` > `Catalog` > `DBdoc: Write to File`;
- Ao clicar em **DBdoc: Write to File** será solicitado que seja indicado a pasta onde será salvo o arqui e o nome do mesmo lembrando que o nome do mesmo tem que terminar com a extensão .html. 
- Depois de salvo, abra o arquivo .html em um navegador.

# Exemplo #
## MRN ##
![](https://raw.githubusercontent.com/luizventurote/banco-de-dados-II/master/dicionario-de-dados/exemplo/MRN.png)

## SQL ##
[Script SQL do banco](https://github.com/luizventurote/banco-de-dados-II/blob/master/dicionario-de-dados/exemplo/Script.sql)

## Dicionário de Dados ##

### aluno ###
| CAMPO | TIPO | NULO | EXTRA | COMENTARIOS |
|---|---|---|---|---|
|   |   |   |   |   |
|   |   |   |   |   |
|   |   |   |   |   |