*** Settings ***
Library    RPA.Browser.Selenium
Library    RPA.FileSystem
Library    DateTime
Library    DatabaseLibrary
Library    String

*** Variables ***
${DB_NAME}     dof_exchange
${DB_USER}     root
${DB_HOST}     localhost

*** Tasks ***
Validar Tipo De Cambio Diario
    Open Browser    https://www.dof.gob.mx/indicadores.php    firefox    
    Wait Until Page Contains Element    id=dfecha    timeout=15s

    # Fechas
    ${fecha_dof}=    Get Current Date    result_format=%d/%m/%Y
    ${fecha_db}=     Get Current Date    result_format=%Y-%m-%d

    # Seleccionar indicador
    Select From List By Value    name=cod_tipo_indicador    158

    # Llenar fechas
    Clear Element Text    id=dfecha
    Input Text            id=dfecha    ${fecha_dof}

    Clear Element Text    id=hfecha
    Input Text            id=hfecha    ${fecha_dof}

    # Ejecutar búsqueda
    Click Element    xpath=//img[@alt='consultar']
    Sleep    5s

    # Obtener resultado
    Wait Until Page Contains Element    xpath=//tr[contains(@class,'Celda')]/td[2]
    ${tipo_cambio}=    Get Text    xpath=//tr[contains(@class,'Celda')]/td[2]
    ${tipo_cambio}=    Strip String    ${tipo_cambio}
    ${tipo_cambio}=    Evaluate    "${tipo_cambio}".replace(",", ".")


    Log    Tipo de cambio del día: ${tipo_cambio}

    # Screenshot
    ${fecha_archivo}=    Get Current Date    result_format=%Y%m%d
    Screenshot    filename=screenshot_${fecha_archivo}.png

    # Guardar TXT
    ${contenido}=    Set Variable    Fecha: ${fecha_dof} | Tipo de cambio: ${tipo_cambio}
    Create File    tipo_cambio_${fecha_archivo}.txt    ${contenido}

    # Guardar en MySQL
    Connect To Database
    ...    pymysql
    ...    ${DB_NAME}
    ...    ${DB_USER}
    ...    
    ...    ${DB_HOST}
    ...    3306

    Log To Console    INSERT INTO tipo_cambio (fecha, tipo_cambio) VALUES ('${fecha_db}', '${tipo_cambio}')

    Execute Sql String    INSERT INTO tipo_cambio (fecha, tipo_cambio) VALUES ('${fecha_db}', '${tipo_cambio}')

    Disconnect From Database
    Close Browser
