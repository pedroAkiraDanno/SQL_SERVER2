--Desabilitar as triggers que impedem altera��o nos subscribers
SELECT
      DISTINCT 'DISABLE TRIGGER ' + T.name + ' ON '+ O.NAME +CHAR(13)+CHAR(10) + 'GO' 
FROM
       sys.triggers t
       LEFT JOIN sys.objects o ON t.parent_id = o.object_id


--Verificar o tipo de sincronismo na coluna sync_type
--1 � AUTOMATICO
--2 � NONE

select * from sysmergesubscriptions

update sysmergesubscriptions
set sync_type = 2

--Verificar andamento do processo de replica��o MERGE
SELECT * FROM tiffanybr..MSmerge_history
ORDER BY TIME DESC

select count(*) from msmerge_contents
select count(*) from msmerge_tombstone
Select count(*) from msmerge_genhistory
