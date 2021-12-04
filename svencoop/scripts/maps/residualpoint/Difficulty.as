string load_diff_file =  "scripts/maps/store/rp" + "diff" + ".dat";

void DiffVerify()
{
    File@ file = g_FileSystem.OpenFile(load_diff_file, OpenFile::READ);
    string fileContent;

    if(file !is null && file.IsOpen())
    {
        file.ReadLine(fileContent);

        if( fileContent == "easy" )
        {

        }
        else if( fileContent == "medium" ) 
        {

        }
        else if( fileContent == "hard" ) 
        {

        }
        else if( fileContent == "hardcore" ) 
        {
                
        }

        file.Close();    
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