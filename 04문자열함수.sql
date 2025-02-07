--문자열 함수
select 'abcDEF' , lower('abcDEF'), upper('abcDEF'), initcap('abcDEF')  from dual; 
select lower(first_name), upper(first_name),initcap(first_name) from employees;

--LENGTH -길이, INSTR-문자열 찾기
select first_name,length(first_name),instr(first_name,'a') from employees;

--SUBSTR(타겟, 시작위치, 자를문자개수) -문자열 자르기, concat- 문자열 붙이기
select first_name, substr(first_name, 1,3) from employees;
SELECT CONCAT(FIRST_NAME,LAST_NAME),FIRST_NAME || LAST_NAME FROM EMPLOYEES;

--LPAD - 왼쪽 공백을 특정 값으로 채움
--RPAD - 오른쪽 
SELECT LPAD(FIRST_NAME, 10,'*') FROM EMPLOYEES;
SELECT RPAD(FIRST_NAME, 10,'-') FROM EMPLOYEES;

--TRIM -양쪽공백제거, LTRIM -왼쪽에서 제거 , RTRIM -오른쪽에서 제거
SELECT (' HELLO WORLD ') ,LTRIM(' HELLO WORLD '),RTRIM(' HELLO WORLD ')FROM DUAL;  
SELECT LTRIM('HELLO WORLD','HELLO')FROM DUAL;

--REPLACE(타겟, 찾을문자, 변경문자)
SELECT REPLACE('피카츄 라이츄 파이리 꼬북이 버터블','꼬북이','어니부기') FROM DUAL;

--함수는 NESTED(중첩)이 가능하다.
SELECT REPLACE( REPLACE('피카츄 라이츄 파이리 꼬북이 버터블','꼬북이','어니부기'),' ','>') FROM DUAL;

