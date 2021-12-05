// Lobby Test

array<string> ActivateSomething = { "hl_c05_a1","hl_c05_a2","hl_c05_a3","hl_c06" }; //<- Nombre de los mapas y ademas nombre de los targetnames que quires ser trigereado en el Lobby
string saveDir = "scripts/maps/store/verify_map_lobby_"; // <- Donde quires que lea/guarde los .dat
string Lobby = "random_lobby"; // <- Nombre del mapa donde quieres que se triggere algo

void Lobby()
{
	// Verify( 1 );
	// Nombre del void( Numero en el mapa de la "array" )

	if( string(g_Engine.mapname) == ActivateSomething[0] )
	{
		FirstMapVerify();
	}

	if( string(g_Engine.mapname) == Lobby )
	{
		InTheLobby();
	}

	for( uint i = 1; i < ActivateSomething.length(); i++ )
	{
		if( string(g_Engine.mapname) == ActivateSomething[i] )
		{
			Verify( i );
		}
	}
}

void Verify( int NumberMap )
{
	string saveFile, fileContent, loadfile;
	bool GoBack = false;
	int verify = 0;
	int NumberMap2 = NumberMap + 1;

	for ( int i = 0; i < NumberMap2; i++ )
	{
		loadfile = saveDir + ActivateSomething[i] + ".dat";
		File@ file = g_FileSystem.OpenFile(loadfile, OpenFile::READ);

		if(file !is null && file.IsOpen())
		{
			fileContent;
			file.ReadLine(fileContent);

			if( fileContent == "activated" )
			{
				GoBack = true;
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
				g_EngineFuncs.ServerPrint(" " + saveDir + ActivateSomething[i] + " Ya esta activado" + "\n");
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");

				++verify;
			}
			else
			{
				GoBack = true;
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
				g_EngineFuncs.ServerPrint(" " + saveDir + ActivateSomething[i] + " No esta activado" + "\n");
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
			}

			if( string(g_Engine.mapname) == ActivateSomething[NumberMap] && fileContent != "activated" && verify == NumberMap)
			{
				GoBack = false;
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
				g_EngineFuncs.ServerPrint(" Los anteriores mapas ya han sido activados, continua" + "\n");
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");	
			}

			if( string(g_Engine.mapname) == ActivateSomething[i] && fileContent == "activated" && verify == NumberMap2 )
			{
				GoBack = true;
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
				g_EngineFuncs.ServerPrint(" Este mapa y los anteriros ya estan activos en el lobby" + "\n");
				g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
			}

			file.Close();		
		}
	}
			
	if( !GoBack )
	{
		saveFile = saveDir + ActivateSomething[NumberMap] + ".dat";
		File@ file = g_FileSystem.OpenFile(saveFile, OpenFile::WRITE);
		fileContent = "activated";
				
		if( file.IsOpen() )
		{			
			file.Write( fileContent );	
			file.Close();		

			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
			g_EngineFuncs.ServerPrint(" Acaba de ser guardad este .dat :D \n");
			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
		}
	}
}

void FirstMapVerify()
{
	string saveFile, fileContent, loadfile;
	bool GoBack = false;

	loadfile = saveDir + ActivateSomething[0] + ".dat";
	File@ file = g_FileSystem.OpenFile(loadfile, OpenFile::READ);

	if(file !is null && file.IsOpen())
	{
		fileContent;
		file.ReadLine(fileContent);
		if( fileContent == "activated" )
		{
			GoBack = true;

			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
			g_EngineFuncs.ServerPrint(" " + saveDir + ActivateSomething[0] + " Ya esta activado" + "\n");
			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");

			file.Close();
		}
	}
			
	if( !GoBack )
	{
		saveFile = saveDir + ActivateSomething[0] + ".dat";
		@file = g_FileSystem.OpenFile(saveFile, OpenFile::WRITE);
		fileContent = "activated";
				
		if( file.IsOpen() )
		{			
			file.Write( fileContent );	
			file.Close();		

			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
			g_EngineFuncs.ServerPrint("  Acaba de ser guardad este .dat :D \n");
			g_EngineFuncs.ServerPrint(" //////////////////////////////////////////////////////////////////////////////////// \n");
		}
	}
}

void InTheLobby()
{
	string saveFile, fileContent, loadfile, Verify, Verify2, Verify3, Verify4, Verify5;

	for( uint i = 0; i < ActivateSomething.length(); i++ )
	{
		loadfile = saveDir + ActivateSomething[i] + ".dat";
		File@ file = g_FileSystem.OpenFile(loadfile, OpenFile::READ);

		if(file !is null && file.IsOpen())
		{
			fileContent;
			file.ReadLine(fileContent);

			if( fileContent == "activated" )
			{			
				Verify = ActivateSomething[i];
				g_EngineFuncs.ServerPrint(" " + Verify + " Verify " + "\n");
			}

			g_Scheduler.SetTimeout( "FinByTargetName", 3.5f, Verify, ActivateSomething[i] );

			file.Close();
		}
	}			
}

void FinByTargetName( string name, string comparate )
{
	CBaseEntity@ pEntity = null;

    while( ( @pEntity = g_EntityFuncs.FindEntityByTargetname( pEntity, name ) ) !is null )
	{
		if( name == comparate )
		{
        	g_EntityFuncs.FireTargets( comparate , null, null, USE_TOGGLE, 0.0f, 0.0f);
		}
	}
}
