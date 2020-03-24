
with 
-- количество едтниц товара
tabQtyUser as (
select 19 as chislo from dual
)
-- "табличка" с диапазоном цен
, tableDiaposonPrice as (
select 1 as qty_ot, 5 as qty_po, 100 as price from dual
union select 6, 10, 80 from dual
union select 11, 15, 70 from dual
)
-- итоговый запрос, основан на анадизе остатоков от деления
-- строчка с минимальным значением в поле sumPrice и будет 
-- оптимальным значением, для удобства чтения результатов запроса 
-- есть опциональное поле str_itg
select lv, 
       p_trunc, 
       p_mod, 
       var_1+nvl(var_2, 0) as sumPrice,
       ' '||lv||' шт. '||p_trunc||' раз(а) по '||
          (select price from tableDiaposonPrice where p_trunc >= qty_ot and p_trunc <= qty_po)
          ||'р. и '||p_mod||' по '||(select price from tableDiaposonPrice where p_mod >= qty_ot and p_mod <= qty_po)||'р.' str_itg
from (
       select tabVar.lv as lv,
              tabVar.p_trunc as p_trunc,
              tabVar.p_mod as p_mod
              , (select p_trunc*tabVar.lv*price 
                   from tableDiaposonPrice 
                  where tabVar.lv >= qty_ot
                    and tabVar.lv <= qty_po
                ) var_1
              , (select p_mod*price 
                   from tableDiaposonPrice 
                  where p_mod >= qty_ot
                    and p_mod <= qty_po
                ) var_2
       from (
              select level as lv, 
                     trunc(tabQtyUser.chislo/level) as p_trunc, 
                     mod(tabQtyUser.chislo,level) as p_mod
              from tabQtyUser, dual connect by level <= (select max(qty_po) from tableDiaposonPrice)
            ) tabVar
)

