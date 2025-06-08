CREATE TABLE IF NOT EXISTS tipo_documento (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

INSERT INTO tipo_documento (nome) VALUES
    ('CPF'), ('CNPJ'), ('CNH');

CREATE TABLE IF NOT EXISTS tipo_usuario (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

INSERT INTO tipo_usuario (nome) VALUES
    ('Gestor'), ('Motorista'), ('Aluno');

CREATE TABLE IF NOT EXISTS workspace (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    senha TEXT NOT NULL,
    id_documento INTEGER DEFAULT NULL,
    id_tipo_usuario INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS documento (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_tipo_documento INTEGER NOT NULL,
    numero_documento TEXT NOT NULL,
    orgao_emissor TEXT,
    data_emissao DATE,
    data_validade DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS personal_access_tokens (
    id BIGSERIAL PRIMARY KEY,
    tokenable_type TEXT NOT NULL,
    tokenable_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    token TEXT NOT NULL UNIQUE,
    abilities TEXT,
    last_used_at TIMESTAMP,
    expires_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS endereco (
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
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS instituicao (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    id_endereco INTEGER NOT NULL,
    telefone TEXT,
    email TEXT,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS motorista (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    numero_habilitacao TEXT NOT NULL,
    categoria_habilitacao TEXT NOT NULL,
    data_vencimento_habilitacao DATE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS veiculo (
    id SERIAL PRIMARY KEY,
    id_motorista INTEGER NOT NULL,
    placa TEXT NOT NULL UNIQUE,
    modelo TEXT,
    marca TEXT,
    ano_fabricacao INT,
    cor TEXT,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gestor (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_workspace INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS aluno (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_instituicao INTEGER NOT NULL,
    data_inicio DATE,
    data_termino DATE,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS viagem (
    id SERIAL PRIMARY KEY,
    id_workspace INTEGER NOT NULL,
    id_motorista INTEGER NOT NULL,
    id_veiculo INTEGER NOT NULL,
    data_viagem DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME,
    origem TEXT NOT NULL,
    destino TEXT NOT NULL,
    criado_por INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS aluno_viagem (
    id SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL,
    id_viagem INTEGER NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE documento
    ADD CONSTRAINT fk_documento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE documento
    ADD CONSTRAINT fk_documento_id_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento(id) ON DELETE CASCADE;

ALTER TABLE usuario
    ADD CONSTRAINT fk_usuario_documento FOREIGN KEY (id_documento) REFERENCES documento(id) ON DELETE CASCADE;

ALTER TABLE usuario
    ADD CONSTRAINT fk_usuario_id_tipo_usuario FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id) ON DELETE CASCADE;

ALTER TABLE endereco
    ADD CONSTRAINT fk_endereco_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE instituicao
    ADD CONSTRAINT fk_instituicao_endereco FOREIGN KEY (id_endereco) REFERENCES endereco(id) ON DELETE CASCADE;

ALTER TABLE motorista
    ADD CONSTRAINT fk_motorista_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE veiculo
    ADD CONSTRAINT fk_veiculo_motorista FOREIGN KEY (id_motorista) REFERENCES motorista(id) ON DELETE CASCADE;

ALTER TABLE gestor
    ADD CONSTRAINT fk_gestor_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE gestor
    ADD CONSTRAINT fk_gestor_workspace FOREIGN KEY (id_workspace) REFERENCES workspace(id) ON DELETE CASCADE;

ALTER TABLE aluno
    ADD CONSTRAINT fk_aluno_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;

ALTER TABLE aluno
    ADD CONSTRAINT fk_aluno_instituicao FOREIGN KEY (id_instituicao) REFERENCES instituicao(id) ON DELETE CASCADE;

ALTER TABLE viagem
    ADD CONSTRAINT fk_viagem_workspace FOREIGN KEY (id_workspace) REFERENCES workspace(id);

ALTER TABLE viagem
    ADD CONSTRAINT fk_viagem_motorista FOREIGN KEY (id_motorista) REFERENCES motorista(id);

ALTER TABLE viagem
    ADD CONSTRAINT fk_viagem_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id);

ALTER TABLE viagem
    ADD CONSTRAINT fk_viagem_criado_por FOREIGN KEY (criado_por) REFERENCES gestor(id);

ALTER TABLE aluno_viagem
    ADD CONSTRAINT fk_aluno_viagem_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id);

ALTER TABLE aluno_viagem
    ADD CONSTRAINT fk_aluno_viagem_viagem FOREIGN KEY (id_viagem) REFERENCES viagem(id);

CREATE INDEX IF NOT EXISTS idx_instituicao_nome ON instituicao(nome);
CREATE INDEX IF NOT EXISTS idx_aluno_id_instituicao ON aluno(id_instituicao);
CREATE INDEX IF NOT EXISTS idx_usuario_email ON usuario(email);
CREATE INDEX IF NOT EXISTS idx_documento_id_usuario ON documento(id_usuario);
CREATE INDEX IF NOT EXISTS idx_endereco_id_usuario ON endereco(id_usuario);
CREATE INDEX IF NOT EXISTS idx_endereco_cep ON endereco(cep);
CREATE INDEX IF NOT EXISTS idx_token_tokenable ON personal_access_tokens(tokenable_type, tokenable_id);
CREATE INDEX IF NOT EXISTS idx_motorista_id_usuario ON motorista(id_usuario);
CREATE INDEX IF NOT EXISTS idx_veiculo_id_motorista ON veiculo(id_motorista);
CREATE INDEX IF NOT EXISTS idx_aluno_id_usuario ON aluno(id_usuario);
CREATE INDEX IF NOT EXISTS idx_viagem_id_motorista ON viagem(id_motorista);
CREATE INDEX IF NOT EXISTS idx_viagem_id_veiculo ON viagem(id_veiculo);
CREATE INDEX IF NOT EXISTS idx_aluno_viagem_id_aluno ON aluno_viagem(id_aluno);
CREATE INDEX IF NOT EXISTS idx_aluno_viagem_id_viagem ON aluno_viagem(id_viagem);
