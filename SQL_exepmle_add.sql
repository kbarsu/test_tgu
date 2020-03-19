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
  select distinct 
  case
    when bd = p_start then bd
    when to_number(to_char(bd,'mm')) > to_number(to_char(p_start,'mm')) then to_date('01.'||to_char(bd,'mm.yyyy'),'dd.mm.yyyy')
    else p_start
  end t_start, 
  case
    when to_number(to_char(bd,'mm')) < to_number(to_char(p_end,'mm')) then last_day(bd)
    when bd = p_end then bd
    else p_end
  end t_end
      from (
        select p_start+level-1 bd 
        from dual connect by level <= p_end 
        - p_start
      ) where bd between p_start and p_end
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