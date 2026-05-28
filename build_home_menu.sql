SET DEFINE OFF;
CREATE OR REPLACE VIEW V_SCAFF_HOME_MENU AS
SELECT 
    'Materiaal Aanvraag' AS card_title,
    'fa-robot'           AS card_icon,
    'f?p=&APP_ID.:10:&SESSION.' AS card_link,
    1 AS display_order
FROM dual
UNION ALL
SELECT 
    'Retour Aanvraag',
    'fa-undo',
    'f?p=&APP_ID.:20:&SESSION.',
    2
FROM dual
UNION ALL
SELECT 
    'Transfer Aanvraag',
    'fa-truck',
    'f?p=&APP_ID.:30:&SESSION.',
    3
FROM dual;
/

CREATE OR REPLACE PACKAGE PKG_SCAFF_UI AS
    PROCEDURE render_mobile_css;
END PKG_SCAFF_UI;
/

CREATE OR REPLACE PACKAGE BODY PKG_SCAFF_UI AS
    PROCEDURE render_mobile_css IS
    BEGIN
        htp.p('<style>
            .a-CardView-item {
                border: 2px solid #D10000 !important;
                border-radius: 4px;
                background-color: #F8F9FA;
                margin-bottom: 15px;
                text-align: center;
            }
            .a-CardView-title {
                font-size: 1.2rem !important;
                font-weight: bold;
                padding: 10px;
            }
            .a-CardView-icon {
                font-size: 3rem !important;
                color: #000;
                margin: 20px 0;
            }
            .t-Header-branding {
                background-color: #D10000 !important;
            }
        </style>');
    END render_mobile_css;
END PKG_SCAFF_UI;
/
