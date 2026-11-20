-- 요금제별 «고객 한 명이 한 해(2025년) 평균 몇 번 문의했나»
--
-- 조인 규칙(목요일): 문의를 고객별로 먼저 집계 → customers를 왼쪽에 둔 LEFT JOIN
--
-- 분모: customers 전체 고객(50,000명). 문의가 0건인 고객(26,602명)도 0건으로 넣는다.
-- 기간: support_tickets.created_date 2025-01-01 ~ 2025-12-31 (데이터가 2025년만 있음. 명시적으로 거름)
-- 주의: 2025년 가입자·2025년 이탈자는 한 해를 다 채우지 않았지만 분모에 그대로 넣었다.

WITH tickets_per_customer AS (
    SELECT
        customer_id,
        COUNT(*) AS ticket_cnt
    FROM support_tickets
    WHERE created_date >= DATE '2025-01-01'
      AND created_date <  DATE '2026-01-01'
    GROUP BY customer_id
)
SELECT
    c.plan_type                                         AS 요금제,
    COUNT(*)                                            AS 고객수,
    SUM(COALESCE(t.ticket_cnt, 0))                      AS 문의건수,
    ROUND(AVG(COALESCE(t.ticket_cnt, 0)), 3)            AS 고객당_연평균_문의
FROM customers AS c
LEFT JOIN tickets_per_customer AS t
       ON t.customer_id = c.customer_id
GROUP BY c.plan_type
ORDER BY 고객당_연평균_문의 DESC;

-- 검산: 합계가 고객수 50,000 · 문의건수 32,789 와 맞아야 한다.
-- 한 행(예: 알뜰)은 아래처럼 조인 없이 따로 세어 맞춘다.
-- SELECT COUNT(*) AS 문의건수
-- FROM support_tickets
-- WHERE customer_id IN (SELECT customer_id FROM customers WHERE plan_type = '알뜰')
--   AND created_date >= DATE '2025-01-01' AND created_date < DATE '2026-01-01';
