CREATE DATABASE aluno_teste;
USE aluno_teste;

-- -----------------------------------------------------
-- turma
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS turma (
  id INT NOT NULL,
  nome VARCHAR(5) NOT NULL COMMENT 'Nome da turma.',
  ano INT NULL COMMENT 'Ano inicial da turma.',
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- aluno
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS aluno (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  nascimento DATE NULL COMMENT 'Data de nascimento do aluno.',
  email VARCHAR(30) NULL,
  endereço VARCHAR(50) NULL,
  turma_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_aluno_Turma_idx (turma_id ASC),
  CONSTRAINT fk_aluno_Turma
    FOREIGN KEY (turma_id)
    REFERENCES turma (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;