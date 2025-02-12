--DML문
--INSERT
DESC DEPARTMENTS;   --테이블의 구조를 빠르게 확인
--1ST (컬럼을 정확히 일치시키는 경우)
INSERT INTO DEPARTMENTS values(280, 'DEVELOPER', NULL, 1700);
select * from departments;
--DML문은 트랜잭션이 항상 적용이 됩니다.
ROLLBACK;
--2ND(컬럼을 지정해서 넣는 경우)
insert into departments(department_id, department_name, location_id) values(280, 'developer',1700);
insert into departments(department_id, department_name, location_id) values(290, 'dba',1700);

--INSERT구문도 서브쿼리가 됩니다.
--실습을 위한 사본테이블 생성
CREATE TABLE EMPS AS ( SELECT * FROM EMPLOYEES WHERE 1 = 2); -- EMPS테이블 만드는데 데이터는 복제X
DESC EMPS;
SELECT * FROM EMPS;
--1ST
INSERT INTO EMPS (EMPLOYEE_ID,LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
(SELECT EMPLOYEE_ID,LAST_NAME,EMAIL,HIRE_DATE ,JOB_ID FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN');
--2ND
INSERT INTO EMPS (EMPLOYEE_ID,LAST_NAME,EMAIL,HIRE_DATE, JOB_ID)
VALUES ((SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE FIRST_NAME = 'LEX'), 'EXAMPLE','EXAMPLE',SYSDATE,'EXAMPLE');

-------------------------------------------------------------------------------------------------------------
--UPDATE구문
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 120;
UPDATE EMPS SET FIRST_NAME = 'HONG',SALARY=3000, COMMISSION_PCT = 0.1 WHERE EMPLOYEE_ID = 120; --반드시 WHERE을 붙여줘야함
ROLLBACK;
--UPDATE문 서브쿼리
UPDATE EMPS
SET(MANAGER_ID, JOB_ID, SALARY)=
    (SELECT MANAGER_ID, JOB_ID, SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 120;

--------------------------------------------------------------------------------
--DELETE문
--삭제하기 전에 SELECT로 삭제할 데이터를 꼭 확인하세요.
SELECT * FROM EMPS;
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 121;
DELETE FROM EMPS WHERE EMPLOYEE_ID = 120;
--DELETE서브쿼리
DELETE FROM EMPS WHERE job_ID = (SELECT job_id FROM EMPS WHERE EMPLOYEE_ID = 121);

--부서테이블
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;
--50번 부서는 EMPLOYEES테이블에서 참조되고 있기 때문에 삭제가 일어나면 참조무결성 제약을 위배됩니다. 삭제가 안됨!
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 50;

----------------------------------------------------------------------------------------
--MERGE문: 데이터가 있으면 UPDATE ,없으면 INSERT를 문장을 수행하는 병합 구문
SELECT * FROM EMPS;

MERGE INTO EMPS E1 --MERGE를 시킬 타켓테이블
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN')E2 --병합할 테이블(서브쿼리)
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID) --E1과 E2 데이터가 연결되는 조건
WHEN MATCHED THEN -- 일치할 때 수행할 작업
    UPDATE SET E1.SALARY = E2.SALARY,
               E1.COMMISSION_PCT = E2.COMMISSION_PCT 
WHEN NOT MATCHED THEN --일치하지 않을 때 수행할 작업
    INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID) 
    VALUES(E2.EMPLOYEE_ID ,E2.LAST_NAME,E2.EMAIL,E2.HIRE_DATE,E2.JOB_ID);
    
ROLLBACK;
DESC EMPS;

--2ND --MERGE문으로 직접 특정 데이터에 값을 넣고자 할 때 사용할 수 있음
MERGE INTO EMPS E1
USING DUAL
ON(E1.EMPLOYEE_ID = 200)
WHEN MATCHED THEN
    UPDATE SET E1.SALARY = 10000,
               E1.HIRE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT(LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
    VALUES('EXAMPLE','EXAMPLE',SYSDATE,'EXAMPLE');

SELECT * FROM EMPS;

--사본테이블 만들기 (연습용으로 씀)
CREATE TABLE EMP1 AS (SELECT * FROM EMPLOYEES); --테이블 구조 + 테이블 복사
SELECT * FROM EMP1;
CREATE TABLE EMP2 AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); -- 테이블 구조만 복사
SELECT * FROM EMP2;

DROP TABLE EMP1; --테이블 삭제
DROP TABLE EMP2;

------------------------------------
--연습문제
--문제 1.
--DEPTS테이블을 데이터를 포함해서 생성하세요.
--DEPTS테이블의 다음을 INSERT 하세요.
rollback;
DROP TABLE depts;
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS);

SELECT * FROM DEPTS;
INSERT INTO DEPTS 
values(280, '개발', NULL, 1800);
INSERT INTO DEPTS 
values(290, '회계부', NULL, 1800);
INSERT INTO DEPTS 
values(300, '재정', 301, 1800);
INSERT INTO DEPTS 
values(310, '인사', 302, 1800);
INSERT INTO DEPTS 
values(320, '영업', 303, 1700);


--문제 2.
--DEPTS테이블의 데이터를 수정합니다
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
--2. department_id가 290인 데이터의 manager_id를 301로 변경
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 , 매니저아이디를 303으로, 지역아이디를
--1800으로 변경하세요
--4. 부서번호 (290, 300, 310, 320) 의 매니저아이디를 301로 한번에 변경하세요.
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT bank'
WHERE DEPARTMENT_NAME = 'IT Support';

UPDATE DEPTS
SET MANAGER_ID = 301 
WHERE DEPARTMENT_ID = 290;

UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT Help', MANAGER_ID = 303, LOCATION_ID = 1800
WHERE DEPARTMENT_NAME = 'IT Helpdesk';

UPDATE DEPTS
SET DEPARTMENT_ID = 301
WHERE DEPARTMENT_ID IN (290,300,310,320);

SELECT * FROM DEPTS;

--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
DELETE FROM DEPTS WHERE DEPARTMENT_NAME = '영업';
--2. 부서명 NOC를 삭제하세요
DELETE FROM DEPTS WHERE DEPARTMENT_NAME = 'NOC';
--
--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제해 보세요.
SELECT * FROM DEPTS WHERE DEPARTMENT_ID > 200;
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
SELECT * FROM DEPTS WHERE MANAGER_ID IS NOT NULL;
UPDATE DEPTS SET MANAGER_ID = 100 WHERE MANAGER_ID IS NOT NULL;
--3. Depts 테이블은 타겟 테이블 입니다.
--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고, 새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.
MERGE INTO DEPTS D1
USING DEPARTMENTS D
ON(D1.DEPARTMENT_ID = D.DEPARTMENT_ID)
WHEN MATCHED THEN
    UPDATE SET
        D1.DEPARTMENT_NAME = D.DEPARTMENT_NAME,
        D1.MANAGER_ID = D.MANAGER_ID,
        D1.LOCATION_ID = D.LOCATION_ID
WHEN NOT MATCHED THEN
    INSERT(DEPARTMENT_ID, DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID)
    VALUES(D.DEPARTMENT_ID,D.DEPARTMENT_NAME,D.MANAGER_ID,D.LOCATION_ID);
--
--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)
CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY > 6000);
SELECT * FROM JOBS_IT;
--2. jobs_it 테이블에 아래 데이터를 추가하세요
INSERT INTO JOBS_IT VALUES('IT_DEV','아이티개발팀',6000,20000);
INSERT INTO JOBS_IT VALUES('NET_DEV','네트워크개발팀',5000,20000);
INSERT INTO JOBS_IT VALUES('SEC_DEV','보안개발팀',6000,19000);
--3. obs_it은 타겟 테이블 입니다
--jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요.
SELECT * FROM JOBS_IT;
MERGE INTO JOBS_IT JI
USING JOBS J
ON(JI.JOB_ID = J.JOB_ID)
WHEN MATCHED THEN
    UPDATE SET
     JI.MIN_SALARY = J.MIN_SALARY,
     JI.MAX_SALARY = J.MAX_SALARY
WHEN NOT MATCHED THEN
    INSERT(JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY)
    VALUES(J.JOB_ID,J.JOB_TITLE,J.MIN_SALARY,J.MAX_SALARY);
