string load_diff_file = "scripts/maps/store/rp_diff.dat";
dictionary dCvars;

void DiffVerify()
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::READ);
    string fileContent, diff_path;

    if( file.IsOpen() )
    {
        file.ReadLine(fileContent);

        if( fileContent == "easy" )
        {
            diff_path = "scripts/maps/store/rp_global_config_easy.cfg"; 
        }
        else if( fileContent == "medium" ) 
        {
            diff_path = "scripts/maps/store/rp_global_config_medium.cfg"; 
        }
        else if( fileContent == "hard" ) 
        {
            diff_path = "scripts/maps/store/rp_global_config_hard.cfg"; 
        }
        else if( fileContent == "hardcore" ) 
        {
           diff_path = "scripts/maps/store/rp_global_config_hardcore.cfg";      
        }
        else
        {
            diff_path = "scripts/maps/store/rp_global_config_easy.cfg"; 
        }

        file.Close();    
    }

    // Take'd from StaticCfg plugin by Outerbeast
    // https://github.com/Outerbeast/Addons/blob/main/StaticCfg.as
    ReadCfg( diff_path );

	array<string> @dCvarsKeys = dCvars.getKeys();
	dCvarsKeys.sortAsc();
	string CvarValue;

	for( uint i = 0; i < dCvarsKeys.length(); ++i )
	{
		dCvars.get( dCvarsKeys[i], CvarValue );
		g_EngineFuncs.CVarSetFloat( dCvarsKeys[i], atof( CvarValue ) );
		g_EngineFuncs.ServerPrint( "StaticCfg: Set CVar " + dCvarsKeys[i] + " " + CvarValue + "\n" );
	}
}

void Diff_Easy( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::WRITE);
    string fileContent = "easy";
                
    if( file.IsOpen() )
    {            
        file.Write( fileContent );    
        file.Close();
    }
}

void Diff_Medium( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::WRITE);
    string fileContent = "medium";
                
    if( file.IsOpen() )
    {            
        file.Write( fileContent );    
        file.Close();
    }
}

void Diff_Hard( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::WRITE);
    string fileContent = "hard";
                
    if( file.IsOpen() )
    {            
        file.Write( fileContent );    
        file.Close();
    }
}

void Diff_HardCore( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::WRITE);
    string fileContent = "hardcore";
                
    if( file.IsOpen() )
    {            
        file.Write( fileContent );    
        file.Close();
    }
}

void ReadCfg( string diff )
{
	File@ pFile = g_FileSystem.OpenFile( diff, OpenFile::READ );

	if( pFile !is null && pFile.IsOpen() )
	{
		while( !pFile.EOFReached() )
		{
			string sLine;
			pFile.ReadLine( sLine );
			if( sLine.SubString(0,1) == "#" || sLine.IsEmpty() )
				continue;

			array<string> parsed = sLine.Split( " " );
			if( parsed.length() < 2 )
				continue;

			dCvars[parsed[0]] = parsed[1];
		}
		pFile.Close();
	}
}