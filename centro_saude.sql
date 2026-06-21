

CREATE DATABASE IF NOT EXISTS centro_saude;
USE centro_saude;

CREATE TABLE IF NOT EXISTS utentes (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    numero_utente VARCHAR(20)  NOT NULL UNIQUE,
    nome          VARCHAR(150) NOT NULL,
    data_nasc     DATE         NOT NULL,
    sexo          VARCHAR(10)  NOT NULL DEFAULT 'Masculino',
    morada        VARCHAR(200),
    telefone      VARCHAR(20),
    email         VARCHAR(100),
    historico     TEXT,
    data_cadastro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS medicos (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    cedula        VARCHAR(20)  NOT NULL UNIQUE,
    nome          VARCHAR(150) NOT NULL,
    especialidade VARCHAR(60)  NOT NULL,
    telefone      VARCHAR(20),
    email         VARCHAR(100),
    activo        TINYINT(1)   NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS triagens (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    utente_id       INT         NOT NULL,
    nivel           VARCHAR(20) NOT NULL,
    queixa          TEXT        NOT NULL,
    sinais_vitais   VARCHAR(200),
    observacoes     TEXT,
    data_hora       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enfermeiro      VARCHAR(100),
    consulta_gerada TINYINT(1)  NOT NULL DEFAULT 0,
    FOREIGN KEY (utente_id) REFERENCES utentes(id)
);

CREATE TABLE IF NOT EXISTS consultas (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    utente_id      INT         NOT NULL,
    medico_id      INT         NOT NULL,
    triagem_id     INT,
    data_agendada  DATETIME    NOT NULL,
    data_realizada DATETIME,
    estado         VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    diagnostico    TEXT,
    observacoes    TEXT,
    FOREIGN KEY (utente_id)  REFERENCES utentes(id),
    FOREIGN KEY (medico_id)  REFERENCES medicos(id),
    FOREIGN KEY (triagem_id) REFERENCES triagens(id)
);

CREATE TABLE IF NOT EXISTS prescricoes (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id  INT          NOT NULL,
    medicamento  VARCHAR(150) NOT NULL,
    dosagem      VARCHAR(80)  NOT NULL,
    posologia    VARCHAR(200) NOT NULL,
    duracao_dias INT          NOT NULL,
    observacoes  TEXT,
    data_emissao DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id)
);

CREATE TABLE IF NOT EXISTS referencias (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id           INT          NOT NULL,
    tipo                  VARCHAR(20)  NOT NULL,
    especialidade_destino VARCHAR(100) NOT NULL,
    hospital_destino      VARCHAR(150),
    motivo                TEXT         NOT NULL,
    prioridade            VARCHAR(30),
    data_emissao          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_validade         DATE,
    utilizada             TINYINT(1)   NOT NULL DEFAULT 0,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id)
);

-- Dados de exemplo
INSERT IGNORE INTO medicos (cedula, nome, especialidade, telefone, email) VALUES
('CED001', 'Dr. Antonio Silva',    'Medicina Geral', '923000001', 'antonio@centro.ao'),
('CED002', 'Dra. Maria Fernandes', 'Pediatria',      '923000002', 'maria@centro.ao'),
('CED003', 'Dr. Jose Lopes',       'Cardiologia',    '923000003', 'jose@centro.ao'),
('CED004', 'Dra. Ana Rodrigues',   'Ginecologia',    '923000004', 'ana@centro.ao');

INSERT IGNORE INTO utentes (numero_utente, nome, data_nasc, sexo, morada, telefone, historico) VALUES
('SNS000001', 'Carlos Alberto Mbemba', '1985-03-15', 'Masculino', 'Rua do Nsosso 12, Uige',        '912111111', 'Sem antecedentes'),
('SNS000002', 'Ana Paula Kinzenze',    '1992-07-22', 'Feminino',  'Av. da Independencia 45, Uige', '912222222', 'Hipertensao arterial'),
('SNS000003', 'Pedro Nzau Luvemba',    '2010-11-08', 'Masculino', 'Bairro Kulambimbi, Uige',       '912333333', 'Vacinas em dia');
