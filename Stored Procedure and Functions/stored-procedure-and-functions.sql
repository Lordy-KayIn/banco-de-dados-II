CREATE DATABASE storeprocedure_and_function;
USE storeprocedure_and_function;

CREATE TABLE Pessoa (
			id INT NOT NULL AUTO_INCREMENT,
			nome VARCHAR(40) NOT NULL,
			data_nascimento DATE NOT NULL,
			cpf VARCHAR(11) NOT NULL UNIQUE,
			PRIMARY KEY(id)
);

CREATE TABLE CNH (
			id INT NOT NULL AUTO_INCREMENT,
			data_vencimento DATE NOT NULL,
			numero_cnh VARCHAR(10) NOT NULL UNIQUE,
			id_pessoa INT NOT NULL,
			PRIMARY KEY(id),
			FOREIGN KEY(id_pessoa) 
			REFERENCES Pessoa(id)
			ON DELETE RESTRICT
);

CREATE TABLE Erro (
			codigo INT NOT NULL,
			significado VARCHAR(50) NOT NULL,
			PRIMARY KEY(codigo)
);


/*------ INSERÇÃO DOS DADOS NA TABELA Pessoa ------*/
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Carl Friedrich Gauss","1777-04-30", "91861741711");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("NiKola Tesla","1856-07-10", "15267894503");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Luiz Alberto","1994-02-21", "25789791802");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Rene Descartes","1596-03-31", "25984765311");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Charles Babbage","1791-12-26", "27845678301");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Matheus Claudino","1995-07-04", "41567890804");
INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES("Leonhard Euler","1707-04-15", "15298764512");

/*------ INSERÇÃO DOS DADOS NA TABELA CNH ------*/
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-05-29","777777777","7");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-08-15","666666666","6");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-07-10","555555555","5");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-10-06","444444444","4");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-08-24","333333333","3");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-11-20","222222222","2");
INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES("2014-04-19","111111111","1");


/*------ INSERÇÃO DOS DADOS NA TABELA Erro ------*/
INSERT INTO Erro VALUES("0", "OPERAÇÃO OK!");
INSERT INTO Erro VALUES("-1", "Campos obrigatórios em branco no registro");
INSERT INTO Erro VALUES("-2", "Valor errado!");
INSERT INTO Erro VALUES("-3", "Registro não existe na tabela");


/*------ CRIAÇÃO DA PROCEDURE PARA INSERÇÃO DE DADOS NA TABELA Pessoa ------*/
DELIMITER $$
CREATE PROCEDURE sp_InserePessoa(IN novo_nome VARCHAR(40), IN nova_data DATE, IN novo_cpf VARCHAR(11))
BEGIN 
	IF(SELECT LENGTH(novo_cpf) != '11') THEN
		SELECT "Código -2 | VALOR ERRADO!" AS Msg_valor_errado;

	ELSEIF((novo_nome !='') && (nova_data !="0000-00-00") && (novo_cpf !='')) THEN
		INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES (novo_nome, nova_data, novo_cpf);
		SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;
	
	ELSEIF((novo_nome = '') || (nova_data = "0000-00-00") || (novo_cpf = '')) THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;
	
	END IF;
END $$
DELIMITER ;



/*------ CRIAÇÃO DA PROCEDURE PARA INSERÇÃO DE DADOS NA TABELA CNH ------*/
DELIMITER $$

CREATE PROCEDURE sp_InsereCNH(IN nova_data DATE, IN novo_numero VARCHAR(10), IN novo_id INT)
BEGIN 
	IF(SELECT LENGTH(novo_numero) != '10') THEN
		SELECT "Código -2 | VALOR ERRADO!" AS Msg_valor_errado;

	ELSEIF((nova_data != "0000-00-00") && (novo_numero != '') && (novo_id != '')) THEN
		INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES (nova_data, novo_numero, novo_id);
		SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;
	
	ELSEIF((nova_data = "0000-00-00") || (novo_numero = '') || (novo_id = '')) THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;
		
	END IF;
END $$
DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE PARA ALTERAÇÃO DE DADOS NA TABELA Pessoa ------*/
DELIMITER $$

CREATE PROCEDURE sp_AlteraPessoa(IN id_atual INT, IN novo_nome VARCHAR(40), IN nova_data DATE, IN novo_cpf VARCHAR(11))
BEGIN
	IF(SELECT LENGTH(novo_cpf) != '11') THEN
		SELECT "Código -2 | VALOR ERRADO!" AS Msg_valor_errado;
	
	ELSEIF((SELECT Pessoa.id FROM Pessoa WHERE id_atual = Pessoa.id) && (id_atual != '') && (novo_nome != '') && (nova_data != "0000-00-00") && (novo_cpf != '')) THEN 
			UPDATE Pessoa, CNH SET Pessoa.nome=novo_nome, Pessoa.data_nascimento=nova_data, Pessoa.cpf=novo_cpf WHERE Pessoa.id=CNH.id_Pessoa AND id_atual = Pessoa.id;
			SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;

	ELSEIF((id_atual = '') || (novo_nome = '') || (nova_data = "0000-00-00") || (novo_cpf = '' )) THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;
	
	ELSEIF(SELECT Pessoa.id FROM Pessoa, CNH WHERE id_atual != Pessoa.id LIMIT 1) THEN
		SELECT "Código -3 | REGISTRO NÃO EXISTE NA TABELA" AS Msg_sem_registo;
		
	END IF;
END $$
DELIMITER ;

/*------ CRIAÇÃO DA PROCEDURE PARA ALTERAÇÃO DE DADOS NA TABELA Pessoa ------*/
DELIMITER $$

CREATE PROCEDURE sp_AlteraCNH(IN id_atual INT, IN nova_data DATE, IN novo_numero VARCHAR(10))
BEGIN 
	
	IF(SELECT LENGTH(novo_numero) != '10') THEN
		SELECT "Código -2 | VALOR ERRADO!" AS Msg_valor_errado;

	ELSEIF((id_atual != '') && (nova_data != "0000-00-00") && (novo_numero != '')) THEN
		UPDATE CNH, Pessoa SET CNH.data_vencimento = nova_data, CNH.numero_cnh = novo_numero WHERE Pessoa.id=CNH.id_Pessoa AND id_atual = Pessoa.id;
		SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;
	
	ELSEIF((id_atual = '') || (nova_data = '') || (nova_data = "0000-00-00")) THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;

	ELSEIF(SELECT CNH.id FROM Pessoa, CNH WHERE id_atual != CNH.id_pessoa LIMIT 1) THEN
		SELECT "Código -3 | REGISTRO NÃO EXISTE NA TABELA" AS Msg_sem_registo;
	
	END IF;
END $$ 
DELIMITER ;

/*------ CRIAÇÃO DA PROCEDURE PARA EXCLUSÃO DE DADOS NA TABELA Pessoa ------*/
DELIMITER $$

CREATE PROCEDURE sp_ExcluirPessoa(IN id_atual INT)
BEGIN 
	IF((id_atual != '') && (SELECT Pessoa.id FROM Pessoa WHERE id_atual = Pessoa.id )) THEN 
		DELETE FROM Pessoa WHERE Pessoa.id = id_atual;/* Talvez seja interesante retirar a Cláusula Where, depois te explico a OBS*/
		SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;
	
	ELSEIF(id_atual = '') THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;
	
	ELSEIF(SELECT Pessoa.id FROM Pessoa WHERE id_atual != Pessoa.id LIMIT 1) THEN
		SELECT "Código -3 | REGISTRO NÃO EXISTE NA TABELA" AS Msg_sem_registo;
		
	END IF;
END $$  
DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE PARA EXCLUSÃO DE DADOS NA TABELA CNH ------*/
DELIMITER $$

CREATE PROCEDURE sp_ExcluirCNH(IN id_atual INT)
BEGIN 
	IF((id_atual != '') && (SELECT CNH.id_pessoa FROM CNH WHERE id_atual = CNH.id_pessoa )) THEN 
		DELETE FROM CNH WHERE CNH.id_pessoa = id_atual;/* Talvez seja interesante retirar a Cláusula Where, depois te explico a OBS*/
		SELECT "Código 0 | OPERAÇÃO OK!" AS Msg_sucesso;
	
	ELSEIF(id_atual = '') THEN 
		SELECT "Código -1 | CAMPO(S) OBRIGATÓRIO(S) EM BRANCO NO REGISTRO" AS Msg_erro_campo;
	
	ELSEIF(SELECT CNH.id_pessoa FROM CNH WHERE id_atual != CNH.id_pessoa LIMIT 1) THEN
		SELECT "Código -3 | REGISTRO NÃO EXISTE NA TABELA" AS Msg_sem_registo;
		
	END IF;
END $$  
DELIMITER ;


/*------ ESCOPO DA CHAMADA DAS PROCEDURES DE INSERSÃO DE REGISTROS ------*/
CALL sp_InserePessoa(/*Nome*/"", /*Data_Nascimento*/"2000-09-08", /*CPF*/"54334554334");
CALL sp_InsereCNH(/*Data_vencimento*/"", /*Numero CNH*/"", /*Id Pessoa*/"");

/*------ ESCOPO DA CHAMADA DAS PROCEDURES DE ALTERAÇÃO DE REGISTROS ------*/
CALL sp_AlteraPessoa(/*Id Pessoa*/"7", /*Nome*/"MatheusCDS", /*Data_Nascimento*/"1995-07-04", /*CPF*/"15298781211");
CALL sp_AlteraCNH(/*Id Pessoa*/"3", /*Data_vencimento*/"2015-05-25", /*Numero CNH*/"66668899766");

/*------ ESCOPO DA CHAMADA DAS PROCEDURES DE EXCLUSÃO DE REGISTROS ------*/
CALL sp_ExcluirPessoa(/*Id Pessoa*/"7");
CALL sp_ExcluirCNH(/*Id Pessoa*/"3");


/*------ CRIAÇÃO DA FUNCTION VERIFICAR CAMPOS PESSOA ------*/
DROP FUNCTION IF EXISTS VerificarCamposPessoa;
DELIMITER $$
    CREATE FUNCTION VerificarCamposPessoa(id INT, nome VARCHAR(40), data_nascimento DATE, cpf VARCHAR(11))
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF((id = '') || (nome = "") || (data_nascimento = "") || (cpf = "")) THEN
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = -1);
			RETURN result;

		ELSE
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = 0);
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;

/*------ CHAMADA DA FUNCTION VERIFICAR CAMPOS PESSOA ------*/ 
SELECT VerificarCamposPessoa(1, "","1777-04-30", "91861741711");
SELECT VerificarCamposPessoa(1, "Carl Friedrich Gauss","1777-04-30", "91861741711");