SET DEFINE OFF;
CREATE OR REPLACE PACKAGE PKG_SCAFF_UI AS
    PROCEDURE draw_mobile_menu;
END PKG_SCAFF_UI;
/

CREATE OR REPLACE PACKAGE BODY PKG_SCAFF_UI AS
    PROCEDURE draw_mobile_menu IS
    BEGIN
        -- Eerst de ALTRAD CSS
        htp.p('<style>
            .altrad-card {
                border: 2px solid #D10000 !important;
                border-radius: 4px;
                background-color: #F8F9FA;
                margin-bottom: 15px;
                text-align: center;
                display: block;
                text-decoration: none;
                color: #333;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .altrad-card:hover {
                background-color: #f1f1f1;
            }
            .altrad-title {
                font-size: 1.4rem;
                font-weight: bold;
                display: block;
                margin-bottom: 15px;
            }
            .altrad-icon {
                font-size: 4rem;
                color: #000;
            }
            .t-Header-branding {
                background-color: #D10000 !important;
            }
        </style>');

        -- Dan de knoppen tekenen
        htp.p('<div class="altrad-menu-container">');
        
        -- Materiaal Aanvraag (Pagina 10)
        htp.p('<a href="f?p=' || v('APP_ID') || ':10:' || v('SESSION') || '" class="altrad-card">');
        htp.p('  <span class="altrad-title">Materiaal Aanvraag</span>');
        htp.p('  <span class="fa fa-robot altrad-icon"></span>');
        htp.p('</a>');

        -- Retour Aanvraag (Pagina 20)
        htp.p('<a href="f?p=' || v('APP_ID') || ':20:' || v('SESSION') || '" class="altrad-card">');
        htp.p('  <span class="altrad-title">Retour Aanvraag</span>');
        htp.p('  <span class="fa fa-undo altrad-icon"></span>');
        htp.p('</a>');

        -- Transfer Aanvraag (Pagina 30)
        htp.p('<a href="f?p=' || v('APP_ID') || ':30:' || v('SESSION') || '" class="altrad-card">');
        htp.p('  <span class="altrad-title">Transfer Aanvraag</span>');
        htp.p('  <span class="fa fa-truck altrad-icon"></span>');
        htp.p('</a>');

        htp.p('</div>');
    END draw_mobile_menu;
END PKG_SCAFF_UI;
/
