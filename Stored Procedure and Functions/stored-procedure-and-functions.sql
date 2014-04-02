CREATE DATABASE store_procedure_and_function;
USE store_procedure_and_function;

CREATE TABLE Pessoa (
			id INT NOT NULL AUTO_INCREMENT,
			nome VARCHAR(40) NOT NULL,
			data_nascimento DATE NOT NULL,
			cpf VARCHAR(12) NOT NULL UNIQUE,
			PRIMARY KEY(id)
);

CREATE TABLE CNH (
			id INT NOT NULL AUTO_INCREMENT,
			data_vencimento DATE NOT NULL,
			numero_cnh VARCHAR(11) NOT NULL UNIQUE,
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


/*------ CRIAÇÃO DA PROCEDURE PARA ALTERAÇÃO DE DADOS NA TABELA PESSOA ------*/
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


/*------ CRIAÇÃO DA PROCEDURE PARA ALTERAÇÃO DE DADOS NA TABELA CNH ------*/
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


/*------ CRIAÇÃO DA FUNCTION TIPO DE ERRO ------*/
DROP FUNCTION IF EXISTS TipoErro;
DELIMITER $$
    CREATE FUNCTION TipoErro(erro INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF(erro = -3) THEN
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = -3);
			RETURN result;

		ELSEIF(erro = -2) THEN
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = -2);
			RETURN result;

		ELSEIF(erro = -1) THEN
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = -1);
			RETURN result;

		ELSE
			SET result = (SELECT CONCAT(Erro.codigo, ' | ', Erro.significado) FROM Erro WHERE Erro.codigo = 0);
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION VERIFICAR CAMPOS PESSOA ------*/
DROP FUNCTION IF EXISTS VerificarCamposPessoa;
DELIMITER $$
    CREATE FUNCTION VerificarCamposPessoa(nome VARCHAR(40), data_nascimento DATE, cpf VARCHAR(12))
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF(SELECT LENGTH(cpf) != 11) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF((nome = "") || (data_nascimento = "") || (data_nascimento = "0000-00-00") || (cpf = "")) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			SET result = ( SELECT TipoErro(-0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION VERIFICAR CAMPOS CNH ------*/
DROP FUNCTION IF EXISTS VerificarCamposCNH;
DELIMITER $$
    CREATE FUNCTION VerificarCamposCNH(data_cnh DATE, numero VARCHAR(11), id_pessoa INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF(SELECT LENGTH(numero) != 10) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF( (data_cnh = "") || (data_cnh = "0000-00-00") || (numero = "") || (id_pessoa = "") ) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION VERIFICAR PESSOA ------*/
DROP FUNCTION IF EXISTS VerificarPessoa;
DELIMITER $$
    CREATE FUNCTION VerificarPessoa(id_pessoa INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (id_pessoa = '') ) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSEIF(SELECT pessoa.id FROM Pessoa WHERE pessoa.id = id_pessoa LIMIT 1) THEN
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		ELSE
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION VERIFICAR CNH ------*/
DROP FUNCTION IF EXISTS VerificarCNH;
DELIMITER $$
    CREATE FUNCTION VerificarCNH(id_cnh INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (id_cnh = '') ) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSEIF(SELECT cnh.id FROM cnh WHERE cnh.id = id_cnh LIMIT 1) THEN
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		ELSE
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION INSERIR PESSOA ------*/
DROP FUNCTION IF EXISTS inserirPessoa;
DELIMITER $$
    CREATE FUNCTION inserirPessoa(novo_nome VARCHAR(40), nova_data DATE, novo_cpf VARCHAR(15))
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF(SELECT LENGTH(novo_cpf) != 11) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF((novo_nome = "") || (nova_data = "") || (nova_data = "0000-00-00") || (novo_cpf = "")) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			INSERT INTO Pessoa(nome, data_nascimento, cpf) VALUES (novo_nome, nova_data, novo_cpf);
			SET result = ( SELECT TipoErro(-0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION INSERIR CNH ------*/
DROP FUNCTION IF EXISTS inserirCNH;
DELIMITER $$
    CREATE FUNCTION inserirCNH( nova_data DATE, novo_numero VARCHAR(11), novo_id INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF(SELECT LENGTH(novo_numero) != 10) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF( (nova_data = "") || (nova_data = "0000-00-00") || (novo_numero = "") || (novo_id = "") ) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			INSERT INTO CNH(data_vencimento, numero_cnh, id_pessoa) VALUES (nova_data, novo_numero, novo_id);
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION PARA ALTERAÇÃO DE DADOS NA TABELA PESSOA ------*/
DROP FUNCTION IF EXISTS AlteraPessoa;
DELIMITER $$
    CREATE FUNCTION AlteraPessoa(id_atual INT, novo_nome VARCHAR(40), nova_data DATE, novo_cpf VARCHAR(11))
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (SELECT COUNT(*) FROM pessoa WHERE pessoa.id = id_atual) != 1) THEN
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		ELSEIF(SELECT LENGTH(novo_cpf) != 11) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF( (id_atual = "") || (novo_nome = "") || (nova_data = "") || (nova_data = "0000-00-00") || (novo_cpf = "")) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			UPDATE pessoa SET pessoa.nome = novo_nome, pessoa.data_nascimento = nova_data, pessoa.cpf = novo_cpf WHERE pessoa.id = id_atual;
			SET result = ( SELECT TipoErro(-0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION PARA ALTERAÇÃO DE DADOS NA TABELA CNH ------*/
DROP FUNCTION IF EXISTS AlteraCNH;
DELIMITER $$
    CREATE FUNCTION AlteraCNH(id_atual INT, nova_data DATE, novo_numero VARCHAR(10))
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (SELECT COUNT(*) FROM pessoa WHERE pessoa.id = id_atual) != 1) THEN
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		ELSEIF(SELECT LENGTH(novo_numero) != 10) THEN
			SET result = ( SELECT TipoErro(-2) );
			RETURN result;

		ELSEIF( (id_atual = "") || (nova_data = "") || (nova_data = "0000-00-00") || (novo_numero = "")) THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;

		ELSE
			UPDATE cnh, pessoa SET cnh.data_vencimento = nova_data, cnh.numero_cnh = novo_numero WHERE pessoa.id = cnh.id_pessoa AND id_atual = pessoa.id;
			SET result = ( SELECT TipoErro(-0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION PARA EXCLUSÃO DE DADOS NA TABELA PESSOA ------*/
DROP FUNCTION IF EXISTS DeletarPessoa;
DELIMITER $$
    CREATE FUNCTION DeletarPessoa(id_atual INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (SELECT COUNT(*) FROM pessoa WHERE pessoa.id = id_atual) != 1) THEN
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		ELSEIF(id_atual = "") THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;
		
		ELSE
			DELETE FROM Pessoa WHERE pessoa.id = id_atual;
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA FUNCTION PARA EXCLUSÃO DE DADOS NA TABELA CNH ------*/
DROP FUNCTION IF EXISTS DeletarCNH;
DELIMITER $$
    CREATE FUNCTION DeletarCNH(id_atual INT)
    RETURNS VARCHAR(100)
    	LANGUAGE SQL
    BEGIN
		DECLARE result VARCHAR(100);

		IF( (SELECT COUNT(*) FROM pessoa WHERE pessoa.id = id_atual) != 1) THEN
			SET result = ( SELECT TipoErro(-3) );
			RETURN result;

		ELSEIF(id_atual = "") THEN
			SET result = ( SELECT TipoErro(-1) );
			RETURN result;
		
		ELSE
			DELETE FROM cnh WHERE cnh.id_pessoa = id_atual;
			SET result = ( SELECT TipoErro(0) );
			RETURN result;

		END IF;
    END;
$$ DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE COM FUNCTION PARA INSERÇÃO DE DADOS NA TABELA Pessoa ------*/
DROP PROCEDURE IF EXISTS spf_InserePessoa;
DELIMITER $$
CREATE PROCEDURE spf_InserePessoa(IN novo_nome VARCHAR(40), IN nova_data DATE, IN novo_cpf VARCHAR(12))
BEGIN 

	SELECT inserirPessoa(novo_nome, nova_data, novo_cpf);

END $$
DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE COM FUNCTION PARA INSERÇÃO DE DADOS NA TABELA CNH ------*/
DROP PROCEDURE IF EXISTS spf_InsereCNH;
DELIMITER $$
CREATE PROCEDURE spf_InsereCNH(IN nova_data DATE, IN novo_numero VARCHAR(11), IN novo_id INT)
BEGIN 
	
	SELECT inserirCNH( nova_data, novo_numero, novo_id);

END $$
DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE COM FUNCTION PARA ALTERAÇÃO DE DADOS NA TABELA PESSOA ------*/
DROP PROCEDURE IF EXISTS spf_AlteraPessoa;
DELIMITER $$
CREATE PROCEDURE spf_AlteraPessoa(IN id_atual INT, IN novo_nome VARCHAR(40), IN nova_data DATE, IN novo_cpf VARCHAR(11))
BEGIN
	
	SELECT AlteraPessoa(id_atual, novo_nome, nova_data, novo_cpf);

END $$
DELIMITER ;


/*------ CRIAÇÃO DA PROCEDURE COM FUNCTION PARA ALTERAÇÃO DE DADOS NA TABELA CNH ------*/
DROP PROCEDURE IF EXISTS spf_AlteraCNH;
DELIMITER $$
CREATE PROCEDURE spf_AlteraCNH(IN id_atual INT, IN nova_data DATE, IN novo_numero VARCHAR(10))
BEGIN
	
	SELECT AlteraCNH(id_atual, nova_data, novo_numero);

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

/*------ CHAMADA DA FUNCTION VERIFICAR CAMPOS PESSOA ------*/ 
SELECT VerificarCamposPessoa(1, "","1777-04-30", "91861741711");
SELECT VerificarCamposPessoa(1, "Carl Friedrich Gauss","1777-04-30", "91861741711");

/*------ CHAMADA DA FUNCTION VERIFICAR CAMPOS CNH ------*/ 
SELECT VerificarCamposCNH(2, "2014-04-19", "111111111", 1);
SELECT VerificarCamposCNH(2, "", "111111111", 1);

/*------ CHAMADA DA FUNCTION INSERIR PESSOA ------ */
SELECT inserirPessoa("Jack Kill", "1994-02-21", "18456978456");

/*------ CHAMADA DA FUNCTION INSERIR CNH ------ */
SELECT inserirCNH("2014-11-05", "1238467899", 1);