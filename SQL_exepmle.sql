-- ----------------
/* итог сверху   */
-- ----------------
with ddd as (
select 'АиРП' as gr1, 'backEnd' as gr2, 'Иванов 1' as nme from dual
union all select 'АиРП', 'backEnd', 'Иванов 2' from dual
union all select 'АиРП', 'backEnd', 'Петров 1' from dual
union all select 'АиРП', 'backEnd', 'Сидоров 1' from dual
union all select 'АиРП', 'frontEnd', 'Сидоров 2' from dual
union all select 'АиРП', 'frontEnd', 'Сидоров 3' from dual
union all select 'АиРП', 'frontEnd', 'Сидоров 4' from dual
)

select  
   DECODE(GROUPING(nme), 1, gr2, nme),
   count(*)   
from ddd
group by rollup(gr2,nme)
ORDER BY GROUPING(gr2),gr2,GROUPING(gr2) - GROUPING(nme), nme


-- ----------------------------------------------
/* 
  Пакет с двумя функциями для разбора XML
  - gettab - возвращает таблицу из XML-документа
    вызов select * from testTGUpack.gettab()
  - getxmltype - приводит XML-документ к формату   
    <root>
      <data row="1" col="1">v11</data>
      <data row="1" col="2">v12</data>
	  .....
    </root>
*/
-- -----------------------------------------------
create or replace noneditionable package testTGUpack is
type itemrec is record (
     valCol_1  varchar2(100),
     valCol_2  varchar2(100),
     valCol_3  varchar2(100),
     valCol_4  varchar2(100)
   );
   type itemstab is table of itemrec;
   function gettab return itemstab pipelined;
   function getxmltype return xmltype;
end;
/

create or replace noneditionable package body testTGUpack is
 function gettab return itemstab pipelined is
 begin
 for i in (
      select
        tseq.extract('/row/col[position()=1]/text()').getStringVal()  valCol_1,
        tseq.extract('/row/col[position()=2]/text()').getStringVal()  valCol_2,
        tseq.extract('/row/col[position()=3]/text()').getStringVal()  valCol_3,
        tseq.extract('/row/col[position()=4]/text()').getStringVal()  valCol_4
      from
        (select XmlType('
          <root>
            <row>
              <col>v11</col>
              <col>v12</col>
              <col>v13</col>
            </row>
            <row>
              <col>v21</col>
              <col>v22</col>
              <col>v23</col>
              <col>v24</col>
            </row>
          </root>') as val from dual
        ) txml,
        table(XmlSequence(txml.val.extract('/root/row'))) tseq
    )
 loop
  pipe row(itemrec(i.valCol_1, i.valCol_2, i.valCol_3, i.valCol_4));
 end loop;
 return;
 end;
    
 function getxmltype return xmltype is
 valCol xmltype;
 begin
  select xmltransform(xml, xsl) into valCol from (
  select
    xmltype('
    <root>
      <row>
        <col>v11</col>
        <col>v12</col>
        <col>v13</col>
      </row>
      <row>
        <col>v21</col>
        <col>v22</col>
        <col>v23</col>
        <col>v24</col>
        <col>v25</col>
      </row>
      <row>
        <col>v31</col>
        <col>v32</col>
      </row>
    </root>
  ') xml,
    xmltype('
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/root">
      <root>
        <xsl:for-each select="/root/row">
        <xsl:variable name="i" select="position()" />

        <xsl:for-each select="./col">
        <xsl:variable name="j" select="position()" />
         
          <data row="{$i}" col="{$j}">
            <xsl:value-of select="."></xsl:value-of>
          </data>
          
          </xsl:for-each>
        
        </xsl:for-each>
      </root>
    </xsl:template>
    </xsl:stylesheet>
  ') xsl
  from dual
  ) xlst;
      
 return valCol;
 end;
    
end;
/























