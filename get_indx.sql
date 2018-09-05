/*


*/


-- 
DELIMITER ;;

-- 阶乘函数
-- 
DROP FUNCTION IF EXISTS factorial_num;;
CREATE FUNCTION factorial_num( n int(2), endnu int(2) ) RETURNS varchar(256)
BEGIN
DECLARE mnum bigint(20) unsigned DEFAULT 1;
-- DECLARE n varchar(256) unsigned DEFAULT 1;
DECLARE temfact varchar(256)  DEFAULT '0';  -- 临时积
DECLARE factnum varchar(256)  DEFAULT '0';  -- 累积值
DECLARE carrybit varchar(256)  DEFAULT '0'; -- 进位
DECLARE unitbit varchar(256)  DEFAULT '';  -- 个位
DECLARE posi int(20) unsigned DEFAULT 0;

SET factnum=n;

	WHILE n>endnu DO
	
		SET n=n-1;
		
		SET posi=0 ;
		while posi < length(factnum) do
			SET temfact=right(left(factnum,length(factnum)-posi),1)*n+carrybit;
			
			SET carrybit=left(temfact,length(temfact)-1);
			SET unitbit=concat( unitbit,right(temfact,1) );
			
			SET posi=posi+1;
		end while;
		
		SET factnum=concat(carrybit,reverse(unitbit));
		SET carrybit='',unitbit='';
		
	END WHILE;
	
--	SET mnum=cast( factnum as UNSIGNED );
	
RETURN (factnum);

END;;
-- DELIMITER ;
/*  -- Testing
select factorial_num(0) fac_num;
select factorial_num(1) fac_num;
select factorial_num(2) fac_num;
select factorial_num(3) fac_num;
select factorial_num(4) fac_num;
select factorial_num(5) fac_num;
select factorial_num(6) fac_num;
select factorial_num(7) fac_num;
select factorial_num(8) fac_num;
select factorial_num(9,3) fac_num;
select factorial_num(10) fac_num;
select factorial_num(11) fac_num;
select factorial_num(12) fac_num;
select factorial_num(13) fac_num;
select factorial_num(14) fac_num;
select factorial_num(15) fac_num;
select factorial_num(16) fac_num;
select factorial_num(20) fac_num;
select factorial_num(21) fac_num;
select factorial_num(22) fac_num;
select factorial_num(23) fac_num;
select factorial_num(24) fac_num;
select factorial_num(25) fac_num;
select factorial_num(26) fac_num;
select factorial_num(27) fac_num;
select factorial_num(28) fac_num;
select factorial_num(29) fac_num;
select factorial_num(30) fac_num;
select factorial_num(31) fac_num;
select factorial_num(32) fac_num;
select factorial_num(33,1) fac_num;
select factorial_num(33,30) fac_num;

select 2+'1' c
select cast( '123' as int ) a
select convert( '123' , UNSIGNED ) a



*/



-- 组合数函数
DROP FUNCTION IF EXISTS combine_num;;
CREATE FUNCTION combine_num( n int, m int) RETURNS bigint(20)
BEGIN
DECLARE comnum bigint(20);
/*
formula:
comnum=C(n,m)
=n!/((n-m)!*m!)
=n*..*(n-m+1)/m!
*/
SET comnum=factorial_num(n,n-m+1)/factorial_num(m,1);

RETURN (comnum);

END;;
/* Testing
select combine_num(33,6) comb_num

*/

-- DELIMITER ;;
-- 求和函数
DROP FUNCTION IF EXISTS idx_no;;
CREATE FUNCTION idx_no( id0 int, id int, ordinal int ) RETURNS bigint(20)
BEGIN
DECLARE msg text default '';
DECLARE	n int(10);
DECLARE	m int(10);
DECLARE	sum1 bigint(20) default 0;

if id between ordinal and ordinal+27
then 
	set msg='Number is normal!' ;
else
	set msg='Number is out of range!';
end if;	
		
	WHILE id-1 > 0 and id0+1 < id DO
		SET id0=id0+1;
		SET sum1=sum1+combine_num((33-id0),(6-ordinal));
		
	END WHILE ;	
RETURN sum1;
END;;
-- DELIMITER ;

/* Testing
select idx_no(0,2,1) sum_num
select idx_no(3,5,4) sum_num

*/



-- 存储过程：计算索引值
DROP FUNCTION IF EXISTS lotidx;;
CREATE FUNCTION lotidx(
  a1 int(2),
  a2 int(2),
  a3 int(2),
  a4 int(2),
  a5 int(2),
  a6 int(2)
  
) RETURNS bigint(20)
BEGIN
DECLARE idx1 bigint(20) DEFAULT 0;
DECLARE	idx2 bigint(20) DEFAULT 0;
DECLARE	idx3 bigint(20) DEFAULT 0;
DECLARE	idx4 bigint(20) DEFAULT 0;
DECLARE	idx5 bigint(20) DEFAULT 0;
DECLARE	idx6 bigint(20) DEFAULT 0;
DECLARE	idx bigint(20) DEFAULT 0;


	SET idx1=idx_no(0,a1,1),
		idx2=idx_no(a1,a2,2),
		idx3=idx_no(a2,a3,3),
		idx4=idx_no(a3,a4,4),
		idx5=idx_no(a4,a5,5),
		idx6=a6-a5,
			
		idx=idx1+idx2+idx3+idx4+idx5+idx6;
	
RETURN (idx);

END;;





/* Testing
select lotidx(1,2,3,4,5,6) idx
select lotidx(1,2,3,4,5,33) idx
select lotidx(1,2,3,5,6,33) idx
select lotidx(28,29,30,31,32,33) idx



*/

DELIMITER ;;
DROP PROCEDURE IF EXISTS sp_get_number_list;;
CREATE PROCEDURE sp_get_number_list()
BEGIN
DECLARE a int(2) default 1;
DECLARE b int(2) default 2;
DECLARE c int(2) default 3;
DECLARE d int(2) default 4;
DECLARE e int(2) default 5;
DECLARE f int(2) default 6;

-- DECLARE 
DECLARE EXIT HANDLER FOR 1054 
GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;


-- 创建样例表
drop table if exists test.t_lot_list;
create table if not exists test.t_lot_list(
idx bigint(20) not null default 0,
a int(2) not null default 0,
b int(2) not null default 0,
c int(2) not null default 0,
d int(2) not null default 0,
e int(2) not null default 0,
f int(2) not null default 0,
primary key(idx)
)partition by hash(idx) partitions 100;

/*
SET a=1,
	b=2,
	c=3,
	d=5,
	e=6,
	f=7 ;
*/

WHILE a<=28 DO

	SET b=a+1 ;
	WHILE b<=29 and b>a DO
		
		SET c=b+1 ;
		WHILE c<=30 and c>b DO
			
			SET d=c+1 ;
			WHILE d<=31 and d>c DO
				
				SET e=d+1 ;
				WHILE e<=32 and e>d DO
					
					SET f=e+1 ;
					WHILE f<=33 and f>e DO
					
						insert into test.t_lot_list
						(idx,a,b,c,d,e,f)
						select lotidx(a,b,c,d,e,f) idx,a,b,c,d,e,f ;
						commit;
											
						SET f=f+1;
					END WHILE;
					
					SET e=e+1;
				END WHILE;
				
				SET d=d+1;
			END WHILE;
			
			SET	c=c+1;
		END WHILE;
		
		SET b=b+1;
	END WHILE;
	
	SET a=a+1;
END WHILE;



END;;


DELIMITER ;

/*
call sp_get_number_list;

select @p1,@p2
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
*/






