-- Step 1: 
CREATE TYPE tipo_documento AS ENUM (
    '1',
    '2',
    '3'
);

CREATE TABLE documento (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    tipo_documento tipo_documento NOT NULL,
    numero_documento TEXT NOT NULL,
    orgao_emissor TEXT,
    data_emissao DATE,
    data_validade DATE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    senha TEXT NOT NULL,
    id_documento INTEGER DEFAULT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE personal_access_token (
    id BIGSERIAL PRIMARY KEY,
    tokenable_type TEXT NOT NULL,
    tokenable_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    abilities TEXT,
    last_used_at TIMESTAMP(0) WITHOUT TIME ZONE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: 
ALTER TABLE documento
    ADD CONSTRAINT fk_documento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE usuario
    ADD CONSTRAINT fk_usuario_documento FOREIGN KEY (id_documento) REFERENCES documento(id) ON DELETE CASCADE;

-- Step 3: 
CREATE TABLE instituicao (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    endereco TEXT,
    telefone TEXT,
    email TEXT,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    rua TEXT NOT NULL,
    numero TEXT,
    complemento TEXT,
    bairro TEXT,
    cidade TEXT NOT NULL,
    estado TEXT NOT NULL,
    cep TEXT NOT NULL,
    principal BOOLEAN DEFAULT false,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE motorista (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    numero_habilitacao TEXT NOT NULL,
    categoria_habilitacao TEXT NOT NULL,
    data_vencimento_habilitacao DATE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE veiculo (
    id SERIAL PRIMARY KEY,
    id_motorista INTEGER NOT NULL,
    placa TEXT NOT NULL UNIQUE,
    modelo TEXT,
    marca TEXT,
    ano_fabricacao INT,
    cor TEXT,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_motorista) REFERENCES motorista(id) ON DELETE CASCADE
);

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_instituicao INTEGER NOT NULL,
    nome_responsavel TEXT,
    telefone_responsavel TEXT,
    data_inicio DATE NOT NULL,
    data_termino DATE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (id_instituicao) REFERENCES instituicao(id) ON DELETE CASCADE,
);

CREATE TABLE gestor (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    funcao TEXT NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE viagem (
    id SERIAL PRIMARY KEY,
    id_motorista INTEGER NOT NULL,
    id_veiculo INTEGER NOT NULL,
    data_viagem DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME,
    origem TEXT NOT NULL,
    destino TEXT NOT NULL,
    criado_por INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_motorista) REFERENCES motorista(id),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id),
    FOREIGN KEY (criado_por) REFERENCES gestor(id)
);

CREATE TABLE aluno_viagem (
    id SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL,
    id_viagem INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id),
    FOREIGN KEY (id_viagem) REFERENCES viagem(id)
);

CREATE INDEX idx_instituicao_nome ON instituicao(nome);
CREATE INDEX idx_aluno_id_instituicao ON aluno(id_instituicao);
CREATE INDEX idx_usuario_email ON usuario(email);
CREATE INDEX idx_documento_id_usuario ON documento(id_usuario);
CREATE INDEX idx_endereco_id_usuario ON endereco(id_usuario);
CREATE INDEX idx_endereco_cep ON endereco(cep);
CREATE INDEX idx_token_tokenable ON personal_access_token(tokenable_type, tokenable_id);
CREATE INDEX idx_motorista_id_usuario ON motorista(id_usuario);
CREATE INDEX idx_veiculo_id_motorista ON veiculo(id_motorista);
CREATE INDEX idx_aluno_id_usuario ON aluno(id_usuario);
CREATE INDEX idx_viagem_id_motorista ON viagem(id_motorista);
CREATE INDEX idx_viagem_id_veiculo ON viagem(id_veiculo);
CREATE INDEX idx_aluno_viagem_id_aluno ON aluno_viagem(id_aluno);
CREATE INDEX idx_aluno_viagem_id_viagem ON aluno_viagem(id_viagem);
