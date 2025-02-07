--문제 1.
--1) 오늘의 환율이 1302.69원 입니다 SALARY컬럼을 한국돈으로 변경해서 소수점 2자리수까지 출력 하세요.
SELECT TO_CHAR(SALARY * 1302.69,'L999,999,999.99') FROM EMPLOYEES;
--2) '20250207' 문자를 2025년 02월 07일 로 변환해서 출력하세요.
SELECT TO_CHAR(TO_DATE('20250207','YYYYMMDD'),'YYYY"년" MM"월" DD"일"') FROM DUAL;
--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.
SELECT  EMPLOYEE_ID AS 사원번호 
,CONCAT(FIRST_NAME,LAST_NAME)AS 사원명, HIRE_DATE AS 입사일자 
,ROUND((SYSDATE - HIRE_DATE)/365,0) AS 근속년수 
FROM EMPLOYEES WHERE ROUND((SYSDATE - HIRE_DATE)/365,0)>=10 ORDER BY 근속년수 DESC;

--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
--조건 2) DECODE구문으로 표현해보세요.
--조건 3) CASE구문으로 표현해보세요.
SELECT FIRST_NAME ,MANAGER_ID, JOB_ID ,DECODE(MANAGER_ID,'100','부장','120','과장','121','대리','122','주임','사원')FROM EMPLOYEES WHERE DEPARTMENT_ID = '50';
SELECT FIRST_NAME ,MANAGER_ID, JOB_ID 
       ,CASE WHEN MANAGER_ID = '100' THEN '부장'
             WHEN MANAGER_ID = '120' THEN '과장'
             WHEN MANAGER_ID = '121' THEN '대리'
             WHEN MANAGER_ID = '122' THEN '주임'
             ELSE '사원'
        END
FROM EMPLOYEES WHERE DEPARTMENT_ID = '50';


--문제 3. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상 을 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
--조건5) 급여상태는 10000이상이면 '상' 10000~5000이라면 '중', 5000이하라면 '하' 로 출력해주세요.
SELECT * FROM EMPLOYEES;
SELECT CONCAT(FIRST_NAME,LAST_NAME) AS 이름
    ,TO_CHAR(HIRE_DATE,'YYYY"년"MM"월"DD"일"') AS 입사일
    ,TO_CHAR((SALARY + SALARY * NVL(COMMISSION_PCT ,0)) * 1300,'L999,999,999') AS 급여
    ,DECODE( MOD(TRUNC((SYSDATE - HIRE_DATE)/365), 5) , 0 ,'진급대상','진급대상 아님') AS 진급상태 
    ,CASE WHEN SALARY >='10000' THEN '상'
          WHEN SALARY BETWEEN'5000'AND'10000' THEN '중'
          WHEN SALARY <= '5000' THEN '하'
    END AS 급여상태
    
FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL;   