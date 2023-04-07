WITH tb_activate AS (
    SELECT 
        DISTINCT idVendedor,
        MIN(DATE(dtPedido)) AS dtAtivacao
    FROM pedido as t1
    LEFT JOIN item_pedido as t2
    ON t1.idPedido = t2.idPedido
    WHERE t1.dtPedido >='2018-01-01'
        AND t1.dtPedido <= DATE('2018-01-01','+45 DAY')
        AND t2.idVendedor IS NOT NULL
    GROUP BY 1
)

SELECT 
    t1.*, 
    t2.*,
    t3.*,
    t4.*,
    t5.*,
    t6.*,
    (CASE WHEN t7.idVendedor IS NULL THEN 1 ELSE 0 END) as flVendedor
FROM analytics_vendas AS t1

LEFT JOIN analytics_avaliacao AS t2
    ON t1.idVendedor = t2.idVendedor
        AND t1.dtReference = t2.dtReference

LEFT JOIN analytics_cliente AS t3
    ON t1.idVendedor = t3.idVendedor
        AND t1.dtReference = t3.dtReference

LEFT JOIN analytics_entregas AS t4
    ON t1.idVendedor = t4.idVendedor
        AND t1.dtReference = t4.dtReference

LEFT JOIN analytics_pagamentos AS t5
    ON t1.idVendedor = t5.idVendedor
        AND t1.dtReference = t5.dtReference

LEFT JOIN analytics_produto AS t6
    ON t1.idVendedor = t6.idVendedor
        AND t1.dtReference = t6.dtReference

LEFT JOIN tb_activate AS t7
    ON t1.idVendedor = t7.idVendedor
        AND (JULIANDAY(t7.dtAtivacao) - JULIANDAY(t1.dtReference) + t1.qtdRecencia <= 45)

WHERE t1.qtdRecencia <= 45