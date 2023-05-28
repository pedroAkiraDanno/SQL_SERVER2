--Este script permite que sejam derrubadas todas as conex�es existentes em um
----Database espec�fico
SET NOCOUNT ON
DECLARE @spidstr varchar(max)
DECLARE @ConnKilled smallint
DECLARE @DBName AS VARCHAR(max)
DECLARE @withmsg AS BIT
DECLARE @loginame AS VARCHAR(max)

--Var�avel que recebe o nome do database que ser� analisado
SET @DBName = 'abacos'
SET @ConnKilled=0
SET @spidstr = ''
SET @withmsg = 1
SET @loginame = 'WS$BRASPAG'

IF db_id(@DBName) < 4 
BEGIN
	PRINT 'Connections to system databases cannot be killed'
	RETURN
END

--Utilizando a compatibility view sysprocesses, verificamos quais usu�rios
--est�o conectados no database especificado e ent�o montamos dinamicamente
--o comando Kill
SELECT 
	@spidstr=coalesce(@spidstr,',' )+'kill '+convert(varchar(100), spid)+ '; '
FROM 
	master..sysprocesses 
WHERE 
	dbid=db_id(@DBName) AND loginame = @loginame
 
IF LEN(@spidstr) > 0 
BEGIN
	--Execu��o dos comandos Kill gerados

	SELECT 
		@ConnKilled = COUNT(1)
	FROM 
		master..sysprocesses WHERE dbid=db_id(@DBName) AND loginame = @loginame
		
	EXEC(@spidstr)
END

IF @withmsg =1
	PRINT  CONVERT(VARCHAR(10), @ConnKilled) + ' Connection(s) killed for DB '  + @DBName
GO
