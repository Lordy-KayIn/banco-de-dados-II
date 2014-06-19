## O que é um Dicionário de Dados (DD)? ##
O DD é uma listagem organizada de todos os elementos de dados pertinentes ao sistema, com
definições precisas e rigorosas para que se possa conhecer todas as entradas, saídas, componentes
de depósitos e cálculos intermediários.

A estrutura de um banco de dados relacional é armazenada em um dicionário de dados ou catálogo do sistema. O dicionário de dados é composto de um conjunto de relações, idênticas em propriedades às
relações utilizadas para armazenar dados. Elas podem ser consultadas com as mesmas ferramentas utilizadas para consultar relações de tratamento de dados. Nenhum usuário pode modificar as tabelas de dicionário de dados diretamente. Entretanto, os comandos da linguagem de manipulação de dados que criam e destroem os elementos estruturais do banco de dados trabalham para modificar as linhas em tabelas de dicionários de dados.

Em geral, você encontrará os seguintes tipos de informações em um dicionário de dados:

- Definição de colunas que compõe cada tabela;
- Restrição de integridade imposta sobre relações;
- As informações de segurança (qual o usuário tem o direito de realizar o qual operação sobre qual tabela);
- Definições de outros elementos estruturais de um banco de dados, como visualizações e domínios definidos pelo usuário;

Quando um usuário e tentar acessar dados de qualquer maneira, um SGBD relacional primeiro dirige-se ao dicionário de dados para determinar se os elementos do banco de dados que o usuário solicitou fazem realmente parte do esquema. Além disso, o SGBD verifica se o usuário tem os direitos de acesso àquilo que ele está solicitando.

Quando um usuário tenta modificar dados, o SGBD também vai para o dicionário de dados afins de procurar restrições de integridade que podem ter sido colocadas na relação. Se os dados atendem às restrições, a modificação é permitida. Caso contrário, o SGBD retorna uma mensagem de erro e não faz a alteração.

Como todo acesso ao banco de dados relacional é feita através do dicionário de dados, dizemos que os SGBD's relacionais são baseados em um dicionário de dados.

## Dados elementares ##
Os dados elementares correspondem a elementos atómicos, ou seja, elementos sem decomposição no contexto do utilizador. Exemplo: Apesar de se utilizar (na página seguinte) o N_telefone, como um exemplo de descrição de um elemento de dados composto, na maior parte dos contextos este dado é considerado elementar.

## O DD permite inventariar e descrever os seguintes itens: ##

- depósitos de dados;
- fluxos de dados;
- dados elementares que constituem fluxos e depósitos de dados.

Cada entrada no DD é constituída por um identificador e respectiva descrição. A
descrição de cada entrada inclui:

- o seu significado;
- o seu conteúdo (só para dados compostos);
- os valores permitidos e unidades (só para dados elementares);
- A chave primária (só para depósitos de dados).

## Notação utilizada no DD ##
Para descrever de uma forma precisa e concisa cada componente de dados utiliza-se um conjunto de símbolos simples.

 Símbolo | Significado                                                |
---------|------------------------------------------------------------|
 =       | é constituído por ou é definido por                        |
 +       | e (conjunção ou concatenação)                              |
 ()      | enquadram componentes opcionais                            |
 []      | enquadram componentes que são utilizadas alternativamente  |
 &#124;  | separam componentes alternativas enquadradas por [ ]       |
 {}      | enquadram componentes que se repetem 0 ou mais vezes       |
 **      | enquadram comentários                                      |
 @       | identifica a chave primária de um depósito                 |

## information_schema  ##
O information_schema é a estrutura de dicionário de dados utilizada pelo MySQL, nisso está estrutura provém informações referente a quaisquer objetos que estão relacionados neste banco de dados. Podemos extrair desta estrutura informações como privilégios de usuários, nomes de procedimentos armazenados e funções de um determinado schema. 

O termo INFORMATION_SCHEMA descreve a interface padrão ANSI para os metadados do servidor de banco de dados. O INFORMATION_SCHEMA não é um esquema real (banco de dados), mas os dados contidos dentro deste banco de dados virtual pode ser acessado como qualquer outro banco de dados no servidor. Neste modo, a interface INFORMATION_SCHEMA atua como um componente de padronização para aceder a informação sobre o servidor de base de dados e o seu esquema real. As "tabelas" dentro deste banco de dados virtual não são tabelas em tudo, mas os dados em vez de tabelas, como que é puxado de uma variedade de fontes, incluindo o banco de dados mysql sistema subjacente, e as variáveis ​​de sistema do servidor MySQL e contadores. 

Desta forma, as tabelas INFORMATION_SCHEMA são mais parecidas com views do que tabelas.

## Benefícios de uma interface padronizada ##
Existem três principais vantagens para a interface INFORMATION_SCHEMA versus ao comando SHOW: 

- Adesão aos padrões 
- Usando SELECT para recuperar metadados 
- Mais informações do que comandos SHOW

## As views INFORMATION_SCHEMA ##

- INFORMATION_SCHEMA.SCHEMATA
- INFORMATION_SCHEMA.TABLES
- INFORMATION_SCHEMA.TABLE_CONSTRAINTS
- INFORMATION_SCHEMA.COLUMNS
- INFORMATION_SCHEMA.KEY_COLUMN_USAGE
- INFORMATION_SCHEMA.STATISTICS
- INFORMATION_SCHEMA.ROUTINES
- INFORMATION_SCHEMA.VIEWS
- INFORMATION_SCHEMA.CHARACTER_SETS
- INFORMATION_SCHEMA.COLLATIONS
- INFORMATION_SCHEMA.COLLATION_CHARACTER_SET_APPLICABILITY
- INFORMATION_SCHEMA.SCHEMA_PRIVILEGES
- INFORMATION_SCHEMA.USER_PRIVILEGES
- INFORMATION_SCHEMA.TABLE_PRIVILEGES
- INFORMATION_SCHEMA.COLUMN_PRIVILEGES

### INFORMATION_SCHEMA.SCHEMATA ###
A view SCHEMATA mostra informações sobre os bancos de dados no servidor.
```
DESCRIBE INFORMATION_SCHEMA.SCHEMATA;
```
```
SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;
```
Campos contidos INFORMATION_SCHEMA.SCHEMATA:
- **CATALOG_NAME:** Este campo será sempre NULL, o MySQL não tem qualquer conceito de um catálogo. Ele é fornecido para manter a saída padrão ANSI.
- **SCHEMA_NAME:** Este é o nome da base de dados. 
- **DEFAULT_CHARACTER_SET_NAME:** Este é o nome do conjunto de caracteres padrão para o banco de dados. 

SQL_PATH: Este campo será sempre NULL. O MySQL não usar esse valor para "encontrar" os arquivos associados com o banco de dados. É incluído para compatibilidade com o padrão ANSI.

### INFORMATION_SCHEMA.TABLES ###
A view INFORMATION_SCHEMA.TABLES armazena informações sobre as tabelas de banco de dados no servidor.
```
DESCRIBE INFORMATION_SCHEMA.TABLES;
```
```
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'test' AND TABLE_NAME = 'http_auth';
```
Campos contidos INFORMATION_SCHEMA.TABLES:

- **TABLE_CATALOG:** Mais uma vez, será sempre NULL. Mostrado para fins de compatibilidade.
- **TABLE_SCHEMA:** O nome do banco de dados ao qual pertence esta tabela.
- **TABLE_NAME:** O nome da tabela.
- **TABLE_TYPE:** Ou BASE TABLE, TEMPORARY ou VIEW.
- **MOTOR:** O manuseio do mecanismo de armazenamento de dados desta tabela.
- **VERSÃO:** O controle de versão interna do .frm da tabela. Indica quantas vezes o
definição da tabela foi alterada.
- **ROW_FORMAT:** FIXED, COMPRESSED, ou DYNAMIC. Indica o formato de linhas da tabela.
- **TABLE_ROWS:** Mostra o número de linhas em uma tabela.
- **AVG_ROW_LENGTH:** Mostra a duração média, em bytes, de linhas da tabela.
- **DATA_LENGTH:** Mostra o comprimento total, em bytes, dos dados da tabela.
- **MAX_DATA_LENGTH:** Mostra a duração máxima de armazenamento, em bytes, que os dados da tabela pode consumir.
- **INDEX_LENGTH:** Mostra o comprimento total, em bytes, de índices da tabela.
- **DATA_FREE:** Mostra o número de bytes que foram alocados para os dados da tabela, mas
que ainda não foram preenchidas com os dados da tabela.
- **AUTO_INCREMENT:** Mostra o próximo número inteiro para ser usado em AUTO_INCREMENT da tabela
coluna, ou NULL se tal sequência é usada na tabela.
- **CREATE_TIME:** Timestamp de criação inicial da tabela.
- **UPDATE_TIME:** Timestamp do último comando ALTER TABLE na tabela. Se lá não têm houve comandos ALTER TABLE, em seguida, mostra a mesma hora como CREATE_TIME.
- **CHECK_TIME:** timestamp da última vez que um cheque tabela foi realizado sobre a mesa, ou 
NULL se a tabela nunca foi verificada a consistência. 
- **TABLE_COLLATION:** Mostra conjunto de caracteres padrão da tabela e combinação de agrupamento.
- **CHECKSUM:** soma de verificação ao vivo interno para a tabela, ou NULL se nenhum estiver disponível. 
- **CREATE_OPTIONS:** mostra todas as opções usadas na criação da tabela, ou nada, se ninguém tem 
foi usado. 
- **TABLE_COMMENT:** Mostra qualquer comentário usado durante a criação da tabela.

### INFORMATION_SCHEMA.TABLE_CONSTRAINTS ###
A view INFORMATION_SCHEMA.TABLE_CONSTRAINTS exibe as colunas relacionadas a todas as tabelas para os quais existe um índice restringindo.

```
DESCRIBE INFORMATION_SCHEMA.TABLE_CONSTRAINTS;
```
```
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'test';
```
Campos contidos INFORMATION_SCHEMA.TABLE_CONSTRAINTS: 

- **CONSTRAINT_CATALOG:** Mais uma vez, sempre NULL. 
- **CONSTRAINT_SCHEMA:** Nome do banco de dados em que a restrição de tabela (índice) reside. Isto é sempre o mesmo que o valor de TABLE_SCHEMA. 
- **CONSTRAINT_NAME:** Nome da restrição. 
- **TABLE_SCHEMA:** Nome do banco de dados para a tabela na qual o índice é construído. 
- **TABLE_NAME:** Nome da tabela na qual o índice é construído. 
- **CONSTRAINT_TYPE:** PRIMARY KEY, FOREIGN KEY ou UNIQUE, dependendo de qual motor está a lidar com a tabela, e como a chave foi referenciada em uma instrução CREATE TABLE.

### INFORMATION_SCHEMA.COLUMNS ###
A view INFORMATION_SCHEMA.COLUMNS mostra informações detalhadas sobre as colunas contidas nas tabelas do banco de dados do servidor.

```
DESCRIBE INFORMATION_SCHEMA.COLUMNS;
```
```
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'test' AND TABLE_NAME = 'http_auth';

```
Os campos contidos INFORMATION_SCHEMA.COLUMNS são como se segue:

- **TABLE_CATALOG:** Mais uma vez, sempre NULL.
- **TABLE_SCHEMA:** Nome do banco de dados.
- **TABLE_NAME:** Nome da tabela de banco de dados ou view.
- **COLUMN_NAME:** Nome da coluna.
- **ORDINAL_POSITION:** Iniciando com 1, posição de uma coluna na tabela.
- **COLUMN_DEFAULT:** Valor padrão para uma coluna na tabela.
- **IS_NULLABLE:** sim ou não, descrevendo se a coluna permite valores nulos.
- **DATA_TYPE:** mostra apenas a palavra-chave tipo de dados, e não toda a definição de campo, para o coluna.
- **CHARACTER_MAXIMUM_LENGTH:** Mostra o número máximo de caracteres que o campo pode conter.
- **CHARACTER_OCTET_LENGTH:** mostra o comprimento máximo do campo em octetos.
- **NUMERIC_PRECISION:** Mostra a precisão de campos numéricos, ou NULL se um não-numérico tipo de campo.
- **NUMERIC_SCALE:** Mostra a escala de campos numéricos, ou NULL se um tipo de campo não numérico.
- **CHARACTER_SET_NAME:** Mostra o campo do conjunto de caracteres de caracteres, ou NULL se um não caractere tipo de campo.
- **COLLATION_NAME:** Mostra o campo do conjunto agrupamento personagem, ou NULL se um campo não caractere digita.
- **COLUMN_TYPE:** Mostra a definição de campo completo para a coluna.
- **COLUMN_KEY:** Mostra qualquer uma PRI, UNI, MUL, ou em branco. PRI aparece quando a coluna é parte de uma chave primária. UNI aparece quando a coluna é parte de um índice exclusivo. MUL aparece quando a coluna é parte de um índice que permite duplicatas. Aparece em branco para todos outras colunas.
- **EXTRA:** Mostra de alguma informação extra sobre a coluna que o MySQL lojas; por exemplo, a palavra-chave AUTO_INCREMENT.
- **PRIVILEGES:** Mostra uma lista de privilégios disponíveis para o usuário atual para esta coluna.
- **COLUMN_COMMENT:** Mostra o comentário usado durante a criação da tabela.


### INFORMATION_SCHEMA.KEY_COLUMN_USAGE ###
A view INFORMATION_SCHEMA.KEY_COLUMN_USAGE exibe informações sobre as colunas usadas em índices ou restrições de uma tabela.

```
DESCRIBE INFORMATION_SCHEMA.KEY_COLUMN_USAGE;
```
```
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'test' AND TABLE_NAME = 'http_auth';
```
Campos contidos na INFORMATION_SCHEMA.KEY_COLUMN_USAGE: 

- **CONSTRAINT_CATALOG:** Sempre NULL. 
- **CONSTRAINT_SCHEMA:** Nome do banco de dados que contém a restrição. 
- **CONSTRAINT_NAME:** Nome da restrição. 
- **TABLE_CATALOG:** Sempre NULL. 
- **TABLE_SCHEMA:** Nome do banco de dados que contém a tabela na qual a restrição pode ser encontrado. É sempre o mesmo valor que CONSTRAINT_SCHEMA. 
- **TABLE_NAME:** Nome da tabela em que a restrição ou índice opera. 
- **COLUMN_NAME:** Nome da coluna na restrição. 
- **ORDINAL_POSITION:** Posição da coluna no índice ou restrição, a partir do número 1. 
- **POSITION_IN_UNIQUE_CONSTRAINT:** nulo, ou a posição da coluna referemciada em uma restrição FOREIGN KEY que passa a ser um índice exclusivo.


### INFORMATION_SCHEMA.STATISTICS ###

A view INFORMATION_SCHEMA.STATISTICS exibe informações sobre os índices que operam em tabelas ou em views.

```
DESCRIBE INFORMATION_SCHEMA.STATISTICS;
```
```
SELECT * FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'test' AND TABLE_NAME = 'http_auth';
```

Campos contidos na view INFORMATION_SCHEMA.STATISTICS:

- **TABLE_CATALOG:** Sempre NULL.
- **TABLE_SCHEMA:** Nome do banco de dados no qual a tabela reside.
- **TABLE_NAME:** Nome da tabela na qual o índice opera.
- **NON_UNIQUE:** 0 ou 1 Indica se o índice pode conter valores duplicados.
- **INDEX_SCHEMA:** Nome do banco de dados no qual o índice está alojado. É sempre a mesma como TABLE_SCHEMA.
- **INDEX_NAME:** Nome do índice dentro do esquema.
- **SEQ_IN_INDEX:** Mostra a posição desta coluna dentro da chave de índice, a partir de posição 1.
- **COLUMN_NAME:** Nome da coluna na chave de índice.
- **COLLATION:** agrupamento da coluna. Vai ser um índice para uma ordem ascendente, ou NULL para descer.
- **CARDINALITY:** o número de valores exclusivos contidas nesta coluna para esta chave de índice.
- **SUB_PART:** Se um prefixo de um campo de caracteres foi utilizada na criação do índice, SUB_PART irá mostrar o número de caracteres que a coluna do índice utiliza; Caso contrário, NULL.
- **Embalado:** 0, 1, ou DEFAULT, dependendo se o índice está lotado.
- **NULLABLE:** sim ou não, que indica se a coluna pode conter valores nulos.
- **INDEX_TYPE:** Qualquer das BTREE, RTREE, HASH, ou FULLTEXT.
- **COMENTÁRIO:** Qualquer comentário usado durante a criação do índice; caso contrário, em branco.

### INFORMATION_SCHEMA.ROUTINES ###

A view INFORMATION_SCHEMA.ROUTINES exibe detalhes sobre as stored procedures e funções definidas pelo usuário criadas no sistema.

```
 DESCRIBE INFORMATION_SCHEMA.ROUTINES;
```
```
SELECT * FROM INFORMATION_SCHEMA.ROUTINES;
```

### INFORMATION_SCHEMA.VIEWS ###

### INFORMATION_SCHEMA.CHARACTER_SETS ###

### INFORMATION_SCHEMA.COLLATIONS ###

### INFORMATION_SCHEMA.COLLATION_CHARACTER_SET_APPLICABILITY ###

### INFORMATION_SCHEMA.SCHEMA_PRIVILEGES ###

### INFORMATION_SCHEMA.USER_PRIVILEGES ###

### INFORMATION_SCHEMA.TABLE_PRIVILEGES ###

### INFORMATION_SCHEMA.COLUMN_PRIVILEGES ###

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
|    CAMPO   | TIPO        | NULO | EXTRA          | COMENTARIOS                  
|------------|-------------|------|----------------|------------------------------
| id         | INT         | NO   | AUTO_INCREMENT |                                
| nome       | VARCHAR(45) | NO   |	               |                              
| nascimento |	DATE       | SI   |	               | Data de nascimento do aluno.
| email      | VARCHAR(30) | SI   |	               |                              
| endereço   | VARCHAR(50) | SI   |	               |                              
| turma_id   | INT         | NO   |                |                              


### turma ###
|    CAMPO   | TIPO        | NULO | EXTRA          | COMENTARIOS                  
|------------|-------------|------|----------------|------------------------------
| id	     | INT	       | NO	  |                |                              
| nome	     | VARCHAR(5)  | NO	  |                | Nome da turma.               
| ano	     | INT	       | SI	  |                | Ano inicial da turma.



## Conclusão ##
O dicionário de dados é uma ferramenta essencialmente textual que define o significado de toda a informação que entra, sai e é transformada pelo sistema. A sua construção e manutenção é uma das atividades morosa mas crucial. 


## Referências ##
http://www.marilia.unesp.br/Home/Instituicao/Docentes/EdbertoFerneda/BD%20-%20Aspectos%20Basicos.pdf
http://gomeshp.plughosting.com.br/apostilas/ASI_10_DDados_Quest_resp.pdf
http://w3.ualg.pt/~jvo/ep/dd.pdf
http://www.inf.ufrgs.br/~vrqleithardt/Teaching/AULA%20SEMANA%208%20a%2012/Dicionariodados.pdf