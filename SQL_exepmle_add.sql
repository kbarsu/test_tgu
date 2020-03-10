-- таблица(тип), можно использовать и обычную ьалицу
create or replace type t_rec as object(f_start date, f_end date);
/ 
-- табличный тип
create or replace type t_tab as table of t_rec;
/

-- табличная функция 
function f_tab(p_start date, p_end date) return t_tab 
  is
  r_val t_tab := t_tab(); 
begin
 for i in (
   select to_date('01.01.2001','dd.mm.yyyy') as t_start, to_date('01.02.2001','dd.mm.yyyy') as t_end from dual
   union all 
   select to_date('21.01.2001','dd.mm.yyyy'), to_date('24.02.2001','dd.mm.yyyy') from dual
    )
 loop
   r_val.f_start := i.t_start;
   r_val.f_end := i.t_end;
   retval.EXTEND;
   retval(retval.LAST) := r_val;
 end loop;
return r_val;
end;
/

-- вызов в предложении SELECT 
select * from table(f_tab(to_date('15.02.2020','dd.mm.yyyy'),to_date('29.04.2020','dd.mm.yyyy')))