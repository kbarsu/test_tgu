-- таблица(тип), можно использовать и обычную ьалицу
create or replace type t_rec as object(f_start date, f_end date);
/ 
-- табличный тип
create or replace type t_tab as table of t_rec;
/

-- табличная функция 
create or replace function f_tab (p_start date, p_end date)
return t_tab pipelined is
begin
 for i in (
  -- запрос для получения списка дат в указанном периоде
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
  ) where bd between p_start and p_end order by 1

    )
 loop
    -- запонняем табличный тип 
    pipe row(t_rec(i.t_start,i.t_end));
  end loop;
  return;
end;
/

-- вызов в предложении SELECT 
select * from table(f_tab(to_date('15.02.2020','dd.mm.yyyy'),to_date('29.04.2020','dd.mm.yyyy')));


------------------------------
-- табличная функция варинат 2
------------------------------
create or replace function f_tab_1 (p_start date, p_end date)
return t_tab pipelined is
m_def number;
begin
 m_def := to_number(to_char(p_end,'mm')) - to_number(to_char(p_start,'mm')) + 1; 
 for i in (
  -- запрос для получения списка дат в указанном периоде
  select 
  case
    when level = 1 then p_start
    else add_months(trunc(p_start,'mm'), level - 1)    
  end t_start,
  case
    when level = 1 then last_day(p_start)
    when level = m_def then p_end
    else last_day(add_months(trunc(p_start,'mm'), level - 1))
  end t_end
  from dual connect by level <= m_def
    )
 loop
    -- запонняем табличный тип 
    pipe row(t_rec(i.t_start,i.t_end));
  end loop;
  return;
end;
/

-- вызов в предложении SELECT 
select * from table(f_tab_1(to_date('15.02.2020','dd.mm.yyyy'),to_date('28.06.2020','dd.mm.yyyy')));