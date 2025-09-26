---------------------------------------------------------
-------------------Criação de tabelas--------------------
---------------------------------------------------------

--Categoria Ativos
CREATE TABLE categoriaAtivos(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100),
    descricao TEXT
);
--ATIVOS
CREATE TABLE ativos(
	id_ativo INT PRIMARY KEY AUTO_INCREMENT,
    id_categoria INT,
    codigo_ativo INT NOT NULL,
    nome VARCHAR(100) NOT NULL, 
    preco DECIMAL(12,2),
    data_aquisicao DATE NOT NULL,
    vida_util_esperada INT NOT NULL,
    unid_vida_util VARCHAR(20),
    localizacao VARCHAR(150),
    depreciacao_anual DECIMAL(8,2)
    FOREIGN KEY (id_categoria) REFERENCES categoriaativos(id_categoria)
);
--ALERTAS
CREATE TABLE alertas( 
    id_alerta INT PRIMARY KEY AUTO_INCREMENT,
    id_ativo INT,
    tipo_alerta VARCHAR(50) NOT NULL,
    limiar_porcentagem DECIMAL(5,2) NOT NULL,
    limiar_roi DECIMAL (10,2) NOT NULL,
    status_alerta VARCHAR(20) NOT NULL,
    data_criacao DATETIME NOT NULL,
    FOREIGN KEY (id_ativo) REFERENCES ativos(id_ativo)
);

--Usuarios
CREATE TABLE usuarios(
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
 	nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil_acesso VARCHAR(50) NOT NULL,
    re INT NOT NULL
);

--logAuditorias
CREATE TABLE logAuditorias( 
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT, id_ativo INT,
    acao VARCHAR(100) NOT NULL,
    tabela_afetada VARCHAR(100) NOT NULL,
    id_reparo_afetado INT NOT NULL,
    data_hora DATETIME NOT NULL,
    detalhes TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
     FOREIGN KEY (id_ativo) REFERENCES ativos (id_ativo)
);

--Fornecedores
CREATE TABLE fornecedores(
	id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
	nome_empresa VARCHAR(100) NOT NULL,
    cnpj INT NOT NULL,
    telefone VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL
);

--itensReparo
CREATE TABLE itensReparo(
	id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_reparo INT,
    nome_peca VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    custo_unitario DECIMAL(10,2) NOT NULL,
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores (id_fornecedor),
    FOREIGN KEY (id_reparo) REFERENCES reparos (id_reparo)
);

--reparos
CREATE TABLE reparos(
	id_reparo INT PRIMARY KEY AUTO_INCREMENT,
    id_ativo INT,
    data_reparo DATETIME,
    tipo VARCHAR(100),
    descricao TEXT,
    tempo_parada_hora SMALLINT,
    extensao_vida_util INT,
    unid_extensao_vida_util  VARCHAR(20),
    id_usuario INT,
    id_item INT,
    roi_calculado DECIMAL(10,2),
    custo_total_peca DECIMAL (12,2),
    anexos VARCHAR(255),
    FOREIGN KEY (id_ativo) REFERENCES ativos (id_ativo),
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario),
    FOREIGN KEY (id_item) REFERENCES itensreparo (id_item)
);
--------------------------------------------------------------------
--------------------------Populando Banco---------------------------
--------------------------------------------------------------------
--categoriaAtivos
INSERT INTO categoriaAtivos (nome_categoria, descricao) VALUES
('Máquinas Industriais', 'Equipamentos de produção'),
('Veículos', 'Carros e caminhões da frota'),
('Computadores', 'Ativos de TI como servidores e desktops');

--ativos
INSERT INTO ativos (id_categoria, codigo_ativo, nome, preco, data_aquisicao, vida_util_esperada, unid_vida_util, localizacao, depreciacao_anual)
VALUES
(1, 1001, 'Torno Mecânico', 50000.00, '2020-01-10', 10, 'anos', 'Fábrica Setor A', 5000.00),
(2, 2001, 'Caminhão VW', 250000.00, '2021-06-15', 8, 'anos', 'Garagem Principal', 31250.00),
(3, 3001, 'Servidor Dell PowerEdge', 45000.00, '2022-03-01', 5, 'anos', 'Data Center', 9000.00);

--usuarios
INSERT INTO usuarios (nome, email, senha_hash, perfil_acesso, re) VALUES
('João Silva', 'joao@empresa.com', 'hash1234567890', 'Administrador', 12345),
('Maria Souza', 'maria@empresa.com', 'hash0987654321', 'Técnico', 67890);

--Fornecedores
INSERT INTO fornecedores (nome_empresa, cnpj, telefone, email) VALUES
('Peças Industriais LTDA', '12345678000199', '(11) 3333-4444', 'contato@pecas.com'),
('Auto Center Brasil', '98765432000188', '(11) 5555-6666', 'vendas@autocenter.com');

--Reparos
INSERT INTO reparos (id_ativo, data_reparo, tipo, descricao, tempo_parada_hora, extensao_vida_util, unid_extensao_vida_util, id_usuario, roi_calculado, custo_total_peca, anexos)
VALUES
(1, '2023-05-20 09:00:00', 'Preventiva', 'Troca de rolamentos', 5, 2, 'anos', 2, 15.50, 3000.00, 'foto1.jpg'),
(2, '2024-02-10 14:00:00', 'Corretiva', 'Substituição da caixa de câmbio', 48, 3, 'anos', 1, 22.30, 45000.00, 'nota_fiscal.pdf');

--ItensReparo
INSERT INTO itensReparo (id_reparo, nome_peca, quantidade, custo_unitario, id_fornecedor) VALUES
(1, 'Rolamento SKF', 4, 500.00, 1),
(2, 'Caixa de câmbio VW', 1, 45000.00, 2);

--Alertas
INSERT INTO alertas (id_ativo, tipo_alerta, limiar_porcentagem, limiar_roi, status_alerta, data_criacao)
VALUES
(1, 'Manutenção Preventiva', 80.00, 10.00, 'Ativo', NOW()),
(2, 'Custo Elevado', 90.00, 20.00, 'Ativo', NOW());

--LogAuditoria
INSERT INTO logAuditorias (id_usuario, id_ativo, acao, tabela_afetada, id_reparo_afetado, data_hora, detalhes)
VALUES
(1, 1, 'INSERT', 'reparos', 1, NOW(), 'Inserção de reparo preventivo no torno mecânico'),
(2, 2, 'UPDATE', 'ativos', 2, NOW(), 'Atualização de dados do caminhão VW após reparo');


