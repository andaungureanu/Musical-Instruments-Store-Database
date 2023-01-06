CREATE TABLE countries(
	country_id VARCHAR2(2)
	,country_name VARCHAR2(50) CONSTRAINT country_name_nn NOT NULL
);

CREATE UNIQUE INDEX country_id_pk ON countries(country_id);

ALTER TABLE countries ADD(
	CONSTRAINT country_id_pk PRIMARY KEY(country_id)
);

CREATE TABLE categories(
	category_id NUMBER(2)
	,category_name VARCHAR2(30) CONSTRAINT category_name_nn NOT NULL
);

CREATE UNIQUE INDEX category_id_pk ON categories(category_id);

ALTER TABLE categories ADD(
	CONSTRAINT category_id_pk PRIMARY KEY(category_id)
);

CREATE TABLE manufacturers(
	manufacturer_name VARCHAR2(30)
	,country_id VARCHAR2(2)
);

CREATE UNIQUE INDEX manufacturer_name_pk ON manufacturers(manufacturer_name);

ALTER TABLE manufacturers ADD(
	CONSTRAINT manufacturer_name_pk PRIMARY KEY(manufacturer_name)
	,CONSTRAINT manu_country_id_fk FOREIGN KEY(country_id) REFERENCES countries(country_id)
);

CREATE TABLE instruments(
	instrument_id NUMBER(3)
	,instrument_name VARCHAR2(30) CONSTRAINT instrument_name_nn NOT NULL
	,category_id NUMBER(2) CONSTRAINT category_id_nn NOT NULL
	,description VARCHAR2(100)
	,manufacturer_name VARCHAR2(30)
);

CREATE UNIQUE INDEX instrument_id_pk ON instruments(instrument_id);

ALTER TABLE instruments ADD(
	CONSTRAINT instrument_id_pk PRIMARY KEY(instrument_id)
	,CONSTRAINT category_id_fk FOREIGN KEY(category_id) REFERENCES categories(category_id)
	,CONSTRAINT manufacturer_name_fk FOREIGN KEY(manufacturer_name) REFERENCES manufacturers(manufacturer_name)
);

CREATE SEQUENCE instruments_seq
START WITH 280
INCREMENT BY 10
MAXVALUE 990
NOCACHE
NOCYCLE;

CREATE TABLE items(
	item_id NUMBER(6)
	,instrument_id NUMBER(3) CONSTRAINT instrument_id_nn NOT NULL
	,production_date DATE CONSTRAINT production_date_nn NOT NULL
	,details VARCHAR2(50)
	,price NUMBER(6,2) CONSTRAINT price_nn NOT NULL
	,is_sold NUMBER(1) CONSTRAINT is_sold_nn NOT NULL
	,CONSTRAINT price_ck CHECK(price > 0)
    ,CONSTRAINT is_sold_ck CHECK(is_sold IN (0,1))
);

CREATE UNIQUE INDEX item_id_pk ON items(item_id);

ALTER TABLE items ADD(
	CONSTRAINT item_id_pk PRIMARY KEY(item_id)
	,CONSTRAINT instrument_id_fk FOREIGN KEY(instrument_id) REFERENCES instruments(instrument_id)
);

CREATE TABLE customers(
	customer_id NUMBER(6)
	,first_name VARCHAR2(20)
	,last_name VARCHAR2(30) CONSTRAINT last_name_nn NOT NULL
	,email VARCHAR2(60) CONSTRAINT email_nn NOT NULL
	,phone VARCHAR2(15) CONSTRAINT phone_nn NOT NULL
	,address VARCHAR2(50) CONSTRAINT address_nn NOT NULL
	,country_id VARCHAR2(2) CONSTRAINT country_id_nn NOT NULL
	,is_premium NUMBER(1)
	,CONSTRAINT email_uk UNIQUE(email)
	,CONSTRAINT phone_uk UNIQUE(phone)
	,CONSTRAINT is_premium_ck CHECK(is_premium IN (1,0))
);

CREATE UNIQUE INDEX customer_id_pk ON customers(customer_id);

ALTER TABLE customers ADD(
	CONSTRAINT customer_id_pk PRIMARY KEY(customer_id)
	,CONSTRAINT cli_country_id_fk FOREIGN KEY(country_id) REFERENCES countries(country_id)
);

CREATE TABLE orders(
	order_id NUMBER(6)
	,order_date DATE CONSTRAINT order_date_nn NOT NULL
	,arrival_date DATE
	,customer_id NUMBER(6)
	,discount NUMBER(2)
	,amount_to_pay NUMBER(7,2)
);

CREATE UNIQUE INDEX order_id_pk ON orders(order_id);

ALTER TABLE orders ADD(
	CONSTRAINT order_id_pk PRIMARY KEY(order_id)
	,CONSTRAINT customer_id_fk FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE ordered_items(
	ordered_item_id NUMBER(6)
	,item_id NUMBER(6) CONSTRAINT item_id_nn NOT NULL
	,order_id NUMBER(6) CONSTRAINT order_id_nn NOT NULL
    ,CONSTRAINT item_id_uk UNIQUE(item_id)
);

CREATE UNIQUE INDEX ordered_item_id_pk ON ordered_items(ordered_item_id);

ALTER TABLE ordered_items ADD(
	CONSTRAINT ordered_item_id_pk PRIMARY KEY(ordered_item_id)
	,CONSTRAINT item_id_fk FOREIGN KEY(item_id) REFERENCES items(item_id)
	,CONSTRAINT order_id_fk FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

CREATE OR REPLACE TRIGGER premium_discount_for_order
BEFORE INSERT ON orders
FOR EACH ROW
DECLARE
    v_is_premium customers.is_premium%TYPE := 0;
    v_number_of_orders PLS_INTEGER := 0;
BEGIN
    SELECT is_premium
    INTO v_is_premium
    FROM customers c
    WHERE c.customer_id = :NEW.customer_id;

    SELECT COUNT(*)
    INTO v_number_of_orders
    FROM orders o
    WHERE o.customer_id = :NEW.customer_id;

    IF v_is_premium = 1 THEN
        :NEW.discount := 2 * v_number_of_orders;
    END IF;
END;

CREATE OR REPLACE TRIGGER was_sold
AFTER INSERT ON ordered_items
FOR EACH ROW
BEGIN
    UPDATE items i SET is_sold = 1
    WHERE i.item_id = :NEW.item_id;
END;

INSERT INTO countries VALUES('AW', 'Aruba');
INSERT INTO countries VALUES('AF', 'Afghanistan');
INSERT INTO countries VALUES('AO', 'Angola');
INSERT INTO countries VALUES('AI', 'Anguilla');
INSERT INTO countries VALUES('AX', 'Aland Islands');
INSERT INTO countries VALUES('AL', 'Albania');
INSERT INTO countries VALUES('AD', 'Andorra');
INSERT INTO countries VALUES('AE', 'United Arab Emirates');
INSERT INTO countries VALUES('AR', 'Argentina');
INSERT INTO countries VALUES('AM', 'Armenia');
INSERT INTO countries VALUES('AS', 'American Samoa');
INSERT INTO countries VALUES('AQ', 'Antarctica');
INSERT INTO countries VALUES('TF', 'French Southern Territories');
INSERT INTO countries VALUES('AG', 'Antigua and Barbuda');
INSERT INTO countries VALUES('AU', 'Australia');
INSERT INTO countries VALUES('AT', 'Austria');
INSERT INTO countries VALUES('AZ', 'Azerbaijan');
INSERT INTO countries VALUES('BI', 'Burundi');
INSERT INTO countries VALUES('BE', 'Belgium');
INSERT INTO countries VALUES('BJ', 'Benin');
INSERT INTO countries VALUES('BQ', 'Bonaire, Sint Eustatius and Saba');
INSERT INTO countries VALUES('BF', 'Burkina Faso');
INSERT INTO countries VALUES('BD', 'Bangladesh');
INSERT INTO countries VALUES('BG', 'Bulgaria');
INSERT INTO countries VALUES('BH', 'Bahrain');
INSERT INTO countries VALUES('BS', 'Bahamas');
INSERT INTO countries VALUES('BA', 'Bosnia and Herzegovina');
INSERT INTO countries VALUES('BL', 'Saint Barthelemy');
INSERT INTO countries VALUES('BY', 'Belarus');
INSERT INTO countries VALUES('BZ', 'Belize');
INSERT INTO countries VALUES('BM', 'Bermuda');
INSERT INTO countries VALUES('BO', 'Bolivia, Plurinational State of');
INSERT INTO countries VALUES('BR', 'Brazil');
INSERT INTO countries VALUES('BB', 'Barbados');
INSERT INTO countries VALUES('BN', 'Brunei Darussalam');
INSERT INTO countries VALUES('BT', 'Bhutan');
INSERT INTO countries VALUES('BV', 'Bouvet Island');
INSERT INTO countries VALUES('BW', 'Botswana');
INSERT INTO countries VALUES('CF', 'Central African Republic');
INSERT INTO countries VALUES('CA', 'Canada');
INSERT INTO countries VALUES('CC', 'Cocos (Keeling) Islands');
INSERT INTO countries VALUES('CH', 'Switzerland');
INSERT INTO countries VALUES('CL', 'Chile');
INSERT INTO countries VALUES('CN', 'China');
INSERT INTO countries VALUES('CI', 'Cote d''Ivoire');
INSERT INTO countries VALUES('CM', 'Cameroon');
INSERT INTO countries VALUES('CD', 'Congo, The Democratic Republic of the');
INSERT INTO countries VALUES('CG', 'Congo');
INSERT INTO countries VALUES('CK', 'Cook Islands');
INSERT INTO countries VALUES('CO', 'Colombia');
INSERT INTO countries VALUES('KM', 'Comoros');
INSERT INTO countries VALUES('CV', 'Cabo Verde');
INSERT INTO countries VALUES('CR', 'Costa Rica');
INSERT INTO countries VALUES('CU', 'Cuba');
INSERT INTO countries VALUES('CW', 'Curacao');
INSERT INTO countries VALUES('CX', 'Christmas Island');
INSERT INTO countries VALUES('KY', 'Cayman Islands');
INSERT INTO countries VALUES('CY', 'Cyprus');
INSERT INTO countries VALUES('CZ', 'Czechia');
INSERT INTO countries VALUES('DE', 'Germany');
INSERT INTO countries VALUES('DJ', 'Djibouti');
INSERT INTO countries VALUES('DM', 'Dominica');
INSERT INTO countries VALUES('DK', 'Denmark');
INSERT INTO countries VALUES('DO', 'Dominican Republic');
INSERT INTO countries VALUES('DZ', 'Algeria');
INSERT INTO countries VALUES('EC', 'Ecuador');
INSERT INTO countries VALUES('EG', 'Egypt');
INSERT INTO countries VALUES('ER', 'Eritrea');
INSERT INTO countries VALUES('EH', 'Western Sahara');
INSERT INTO countries VALUES('ES', 'Spain');
INSERT INTO countries VALUES('EE', 'Estonia');
INSERT INTO countries VALUES('ET', 'Ethiopia');
INSERT INTO countries VALUES('FI', 'Finland');
INSERT INTO countries VALUES('FJ', 'Fiji');
INSERT INTO countries VALUES('FK', 'Falkland Islands (Malvinas)');
INSERT INTO countries VALUES('FR', 'France');
INSERT INTO countries VALUES('FO', 'Faroe Islands');
INSERT INTO countries VALUES('FM', 'Micronesia, Federated States of');
INSERT INTO countries VALUES('GA', 'Gabon');
INSERT INTO countries VALUES('GE', 'Georgia');
INSERT INTO countries VALUES('GG', 'Guernsey');
INSERT INTO countries VALUES('GH', 'Ghana');
INSERT INTO countries VALUES('GI', 'Gibraltar');
INSERT INTO countries VALUES('GN', 'Guinea');
INSERT INTO countries VALUES('GP', 'Guadeloupe');
INSERT INTO countries VALUES('GM', 'Gambia');
INSERT INTO countries VALUES('GW', 'Guinea-Bissau');
INSERT INTO countries VALUES('GQ', 'Equatorial Guinea');
INSERT INTO countries VALUES('GR', 'Greece');
INSERT INTO countries VALUES('GD', 'Grenada');
INSERT INTO countries VALUES('GL', 'Greenland');
INSERT INTO countries VALUES('GT', 'Guatemala');
INSERT INTO countries VALUES('GF', 'French Guiana');
INSERT INTO countries VALUES('GU', 'Guam');
INSERT INTO countries VALUES('GY', 'Guyana');
INSERT INTO countries VALUES('HK', 'Hong Kong');
INSERT INTO countries VALUES('HM', 'Heard Island and McDonald Islands');
INSERT INTO countries VALUES('HN', 'Honduras');
INSERT INTO countries VALUES('HR', 'Croatia');
INSERT INTO countries VALUES('HT', 'Haiti');
INSERT INTO countries VALUES('HU', 'Hungary');
INSERT INTO countries VALUES('ID', 'Indonesia');
INSERT INTO countries VALUES('IM', 'Isle of Man');
INSERT INTO countries VALUES('IN', 'India');
INSERT INTO countries VALUES('IO', 'British Indian Ocean Territory');
INSERT INTO countries VALUES('IE', 'Ireland');
INSERT INTO countries VALUES('IR', 'Iran, Islamic Republic of');
INSERT INTO countries VALUES('IQ', 'Iraq');
INSERT INTO countries VALUES('IS', 'Iceland');
INSERT INTO countries VALUES('IL', 'Israel');
INSERT INTO countries VALUES('IT', 'Italy');
INSERT INTO countries VALUES('JM', 'Jamaica');
INSERT INTO countries VALUES('JE', 'Jersey');
INSERT INTO countries VALUES('JO', 'Jordan');
INSERT INTO countries VALUES('JP', 'Japan');
INSERT INTO countries VALUES('KZ', 'Kazakhstan');
INSERT INTO countries VALUES('KE', 'Kenya');
INSERT INTO countries VALUES('KG', 'Kyrgyzstan');
INSERT INTO countries VALUES('KH', 'Cambodia');
INSERT INTO countries VALUES('KI', 'Kiribati');
INSERT INTO countries VALUES('KN', 'Saint Kitts and Nevis');
INSERT INTO countries VALUES('KR', 'Korea, Republic of');
INSERT INTO countries VALUES('KW', 'Kuwait');
INSERT INTO countries VALUES('LA', 'Lao People''s Democratic Republic');
INSERT INTO countries VALUES('LB', 'Lebanon');
INSERT INTO countries VALUES('LR', 'Liberia');
INSERT INTO countries VALUES('LY', 'Libya');
INSERT INTO countries VALUES('LC', 'Saint Lucia');
INSERT INTO countries VALUES('LI', 'Liechtenstein');
INSERT INTO countries VALUES('LK', 'Sri Lanka');
INSERT INTO countries VALUES('LS', 'Lesotho');
INSERT INTO countries VALUES('LT', 'Lithuania');
INSERT INTO countries VALUES('LU', 'Luxembourg');
INSERT INTO countries VALUES('LV', 'Latvia');
INSERT INTO countries VALUES('MO', 'Macao');
INSERT INTO countries VALUES('MF', 'Saint Martin (French part)');
INSERT INTO countries VALUES('MA', 'Morocco');
INSERT INTO countries VALUES('MC', 'Monaco');
INSERT INTO countries VALUES('MD', 'Moldova, Republic of');
INSERT INTO countries VALUES('MG', 'Madagascar');
INSERT INTO countries VALUES('MV', 'Maldives');
INSERT INTO countries VALUES('MX', 'Mexico');
INSERT INTO countries VALUES('MH', 'Marshall Islands');
INSERT INTO countries VALUES('MK', 'North Macedonia');
INSERT INTO countries VALUES('ML', 'Mali');
INSERT INTO countries VALUES('MT', 'Malta');
INSERT INTO countries VALUES('MM', 'Myanmar');
INSERT INTO countries VALUES('ME', 'Montenegro');
INSERT INTO countries VALUES('MN', 'Mongolia');
INSERT INTO countries VALUES('MP', 'Northern Mariana Islands');
INSERT INTO countries VALUES('MZ', 'Mozambique');
INSERT INTO countries VALUES('MR', 'Mauritania');
INSERT INTO countries VALUES('MS', 'Montserrat');
INSERT INTO countries VALUES('MQ', 'Martinique');
INSERT INTO countries VALUES('MU', 'Mauritius');
INSERT INTO countries VALUES('MW', 'Malawi');
INSERT INTO countries VALUES('MY', 'Malaysia');
INSERT INTO countries VALUES('YT', 'Mayotte');
INSERT INTO countries VALUES('NA', 'Namibia');
INSERT INTO countries VALUES('NC', 'New Caledonia');
INSERT INTO countries VALUES('NE', 'Niger');
INSERT INTO countries VALUES('NF', 'Norfolk Island');
INSERT INTO countries VALUES('NG', 'Nigeria');
INSERT INTO countries VALUES('NI', 'Nicaragua');
INSERT INTO countries VALUES('NU', 'Niue');
INSERT INTO countries VALUES('NL', 'Netherlands');
INSERT INTO countries VALUES('NO', 'Norway');
INSERT INTO countries VALUES('NP', 'Nepal');
INSERT INTO countries VALUES('NR', 'Nauru');
INSERT INTO countries VALUES('NZ', 'New Zealand');
INSERT INTO countries VALUES('OM', 'Oman');
INSERT INTO countries VALUES('PK', 'Pakistan');
INSERT INTO countries VALUES('PA', 'Panama');
INSERT INTO countries VALUES('PN', 'Pitcairn');
INSERT INTO countries VALUES('PE', 'Peru');
INSERT INTO countries VALUES('PH', 'Philippines');
INSERT INTO countries VALUES('PW', 'Palau');
INSERT INTO countries VALUES('PG', 'Papua New Guinea');
INSERT INTO countries VALUES('PL', 'Poland');
INSERT INTO countries VALUES('PR', 'Puerto Rico');
INSERT INTO countries VALUES('KP', 'Korea, Democratic People''s Republic of');
INSERT INTO countries VALUES('PT', 'Portugal');
INSERT INTO countries VALUES('PY', 'Paraguay');
INSERT INTO countries VALUES('PS', 'Palestine, State of');
INSERT INTO countries VALUES('PF', 'French Polynesia');
INSERT INTO countries VALUES('QA', 'Qatar');
INSERT INTO countries VALUES('RE', 'Réunion');
INSERT INTO countries VALUES('RO', 'Romania');
INSERT INTO countries VALUES('RU', 'Russian Federation');
INSERT INTO countries VALUES('RW', 'Rwanda');
INSERT INTO countries VALUES('SA', 'Saudi Arabia');
INSERT INTO countries VALUES('SD', 'Sudan');
INSERT INTO countries VALUES('SN', 'Senegal');
INSERT INTO countries VALUES('SG', 'Singapore');
INSERT INTO countries VALUES('GS', 'South Georgia and the South Sandwich Islands');
INSERT INTO countries VALUES('SH', 'Saint Helena, Ascension and Tristan da Cunha');
INSERT INTO countries VALUES('SJ', 'Svalbard and Jan Mayen');
INSERT INTO countries VALUES('SB', 'Solomon Islands');
INSERT INTO countries VALUES('SL', 'Sierra Leone');
INSERT INTO countries VALUES('SV', 'El Salvador');
INSERT INTO countries VALUES('SM', 'San Marino');
INSERT INTO countries VALUES('SO', 'Somalia');
INSERT INTO countries VALUES('PM', 'Saint Pierre and Miquelon');
INSERT INTO countries VALUES('RS', 'Serbia');
INSERT INTO countries VALUES('SS', 'South Sudan');
INSERT INTO countries VALUES('ST', 'Sao Tome and Principe');
INSERT INTO countries VALUES('SR', 'Suriname');
INSERT INTO countries VALUES('SK', 'Slovakia');
INSERT INTO countries VALUES('SI', 'Slovenia');
INSERT INTO countries VALUES('SE', 'Sweden');
INSERT INTO countries VALUES('SZ', 'Eswatini');
INSERT INTO countries VALUES('SX', 'Sint Maarten (Dutch part)');
INSERT INTO countries VALUES('SC', 'Seychelles');
INSERT INTO countries VALUES('SY', 'Syrian Arab Republic');
INSERT INTO countries VALUES('TC', 'Turks and Caicos Islands');
INSERT INTO countries VALUES('TD', 'Chad');
INSERT INTO countries VALUES('TG', 'Togo');
INSERT INTO countries VALUES('TH', 'Thailand');
INSERT INTO countries VALUES('TJ', 'Tajikistan');
INSERT INTO countries VALUES('TK', 'Tokelau');
INSERT INTO countries VALUES('TM', 'Turkmenistan');
INSERT INTO countries VALUES('TL', 'Timor-Leste');
INSERT INTO countries VALUES('TO', 'Tonga');
INSERT INTO countries VALUES('TT', 'Trinidad and Tobago');
INSERT INTO countries VALUES('TN', 'Tunisia');
INSERT INTO countries VALUES('TR', 'Turkey');
INSERT INTO countries VALUES('TV', 'Tuvalu');
INSERT INTO countries VALUES('TW', 'Taiwan, Province of China');
INSERT INTO countries VALUES('TZ', 'Tanzania, United Republic of');
INSERT INTO countries VALUES('UG', 'Uganda');
INSERT INTO countries VALUES('UA', 'Ukraine');
INSERT INTO countries VALUES('UK', 'United Kingdom');
INSERT INTO countries VALUES('UM', 'United States Minor Outlying Islands');
INSERT INTO countries VALUES('UY', 'Uruguay');
INSERT INTO countries VALUES('US', 'United States');
INSERT INTO countries VALUES('UZ', 'Uzbekistan');
INSERT INTO countries VALUES('VA', 'Holy See (Vatican City State)');
INSERT INTO countries VALUES('VC', 'Saint Vincent and the Grenadines');
INSERT INTO countries VALUES('VE', 'Venezuela, Bolivarian Republic of');
INSERT INTO countries VALUES('VG', 'Virgin Islands, British');
INSERT INTO countries VALUES('VI', 'Virgin Islands, U.S.');
INSERT INTO countries VALUES('VN', 'Viet Nam');
INSERT INTO countries VALUES('VU', 'Vanuatu');
INSERT INTO countries VALUES('WF', 'Wallis and Futuna');
INSERT INTO countries VALUES('WS', 'Samoa');
INSERT INTO countries VALUES('YE', 'Yemen');
INSERT INTO countries VALUES('ZA', 'South Africa');
INSERT INTO countries VALUES('ZM', 'Zambia');
INSERT INTO countries VALUES('ZW', 'Zimbabwe');

INSERT INTO categories VALUES(1, 'Woodwind');
INSERT INTO categories VALUES(2, 'Brass');
INSERT INTO categories VALUES(3, 'Stringed');
INSERT INTO categories VALUES(4, 'Percussion');
INSERT INTO categories VALUES(5, 'Keyboard');

INSERT INTO manufacturers VALUES('Gibson', 'US');
INSERT INTO manufacturers VALUES('Fender', 'US');
INSERT INTO manufacturers VALUES('Ernie Ball', 'US');
INSERT INTO manufacturers VALUES('DR Strings', 'US');
INSERT INTO manufacturers VALUES('Yamaha', 'JP');
INSERT INTO manufacturers VALUES('Jupiter Band Instruments', 'TW');
INSERT INTO manufacturers VALUES('Keilwerth', 'DE');
INSERT INTO manufacturers VALUES('Getzen', 'US');
INSERT INTO manufacturers VALUES('Natal Drums', 'UK');
INSERT INTO manufacturers VALUES('Rogers Drums', 'US');
INSERT INTO manufacturers VALUES('Sonor', 'DE');
INSERT INTO manufacturers VALUES('Yamaha Drums', 'JP');
INSERT INTO manufacturers VALUES('Meinl Percussion', 'DE');
INSERT INTO manufacturers VALUES('Ashton Music', 'AU');
INSERT INTO manufacturers VALUES('Roland', 'JP');
INSERT INTO manufacturers VALUES('Kawai', 'JP');
INSERT INTO manufacturers VALUES('Casio', 'JP');
INSERT INTO manufacturers VALUES('Korg', 'JP');
INSERT INTO manufacturers VALUES('Ibanez', 'JP');

INSERT INTO instruments VALUES(10, 'Saxophone', 1, '', 'Jupiter Band Instruments');
INSERT INTO instruments VALUES(20, 'Flute', 1, '', 'Yamaha');
INSERT INTO instruments VALUES(30, 'Basson', 1, '', 'Keilwerth');
INSERT INTO instruments VALUES(40, 'Piccolo', 1, '', 'Jupiter Band Instruments');
INSERT INTO instruments VALUES(50, 'Harmonica', 1, '', 'Yamaha');
INSERT INTO instruments VALUES(60, 'Trombone', 2, '', 'Getzen');
INSERT INTO instruments VALUES(70, 'Trumpet', 2, '', 'Keilwerth');
INSERT INTO instruments VALUES(80, 'Cornet', 2, '', 'Getzen');
INSERT INTO instruments VALUES(90, 'Tuba', 2, '', 'Yamaha');
INSERT INTO instruments VALUES(100, 'Guitar', 3, '', 'Gibson');
INSERT INTO instruments VALUES(110, 'Electric guitar', 3, '', 'Ibanez');
INSERT INTO instruments VALUES(120, 'Violin', 3, '', 'Fender');
INSERT INTO instruments VALUES(130, 'Cello', 3, '', 'Gibson');
INSERT INTO instruments VALUES(140, 'Viola', 3, '', 'Yamaha');
INSERT INTO instruments VALUES(150, 'Bass', 3, '', 'Fender');
INSERT INTO instruments VALUES(160, 'Banjo', 3, '', 'Ibanez');
INSERT INTO instruments VALUES(170, 'Drums', 4, '', 'Natal Drums');
INSERT INTO instruments VALUES(180, 'Maracas', 4, '', 'Meinl Percussion');
INSERT INTO instruments VALUES(190, 'Cymbals', 4, '', 'Rogers Drums');
INSERT INTO instruments VALUES(200, 'Xylophones', 4, '', 'Sonor');
INSERT INTO instruments VALUES(210, 'Tambourine', 4, '', 'Yamaha Drums');
INSERT INTO instruments VALUES(220, 'Piano', 5, '', 'Yamaha');
INSERT INTO instruments VALUES(230, 'Accordion', 5, '', 'Casio');
INSERT INTO instruments VALUES(240, 'Electronic keyboard', 5, '', 'Roland');
INSERT INTO instruments VALUES(250, 'Harpsichord', 5, '', 'Kawai');
INSERT INTO instruments VALUES(260, 'Pipe Organ', 5, '', 'Yamaha');
INSERT INTO instruments VALUES(270, 'Synthesizer', 5, '', 'Korg');

INSERT INTO items VALUES(1, 20, TO_DATE('02-04-2018', 'dd-MM-yyyy'), '', 1583.35, 0);
INSERT INTO items VALUES(2, 140, TO_DATE('23-05-2009', 'dd-MM-yyyy'), '', 1015.75, 0);
INSERT INTO items VALUES(3, 260, TO_DATE('02-08-2001', 'dd-MM-yyyy'), '', 2659.65, 0);
INSERT INTO items VALUES(4, 70, TO_DATE('09-01-2000', 'dd-MM-yyyy'), '', 2337.95, 0);
INSERT INTO items VALUES(5, 200, TO_DATE('17-11-2004', 'dd-MM-yyyy'), '', 2203.40, 0);
INSERT INTO items VALUES(6, 260, TO_DATE('07-02-2012', 'dd-MM-yyyy'), '', 843.15, 0);
INSERT INTO items VALUES(7, 70, TO_DATE('12-10-2009', 'dd-MM-yyyy'), '', 1818.55, 0);
INSERT INTO items VALUES(8, 140, TO_DATE('01-03-2019', 'dd-MM-yyyy'), '', 2059.15, 0);
INSERT INTO items VALUES(9, 100, TO_DATE('22-11-2011', 'dd-MM-yyyy'), '', 2031.25, 0);
INSERT INTO items VALUES(10, 160, TO_DATE('14-12-2005', 'dd-MM-yyyy'), '', 2852.60, 0);
INSERT INTO items VALUES(11, 100, TO_DATE('24-03-2000', 'dd-MM-yyyy'), '', 1089.95, 0);
INSERT INTO items VALUES(12, 260, TO_DATE('07-06-2017', 'dd-MM-yyyy'), '', 2412.90, 0);
INSERT INTO items VALUES(13, 90, TO_DATE('21-10-2022', 'dd-MM-yyyy'), '', 2043.65, 0);
INSERT INTO items VALUES(14, 260, TO_DATE('22-07-2015', 'dd-MM-yyyy'), '', 2642.75, 0);
INSERT INTO items VALUES(15, 90, TO_DATE('01-01-2004', 'dd-MM-yyyy'), '', 241.75, 0);
INSERT INTO items VALUES(16, 200, TO_DATE('07-05-2011', 'dd-MM-yyyy'), '', 1123.95, 0);
INSERT INTO items VALUES(17, 170, TO_DATE('11-02-2001', 'dd-MM-yyyy'), '', 1030.15, 0);
INSERT INTO items VALUES(18, 170, TO_DATE('06-12-2022', 'dd-MM-yyyy'), '', 48.30, 0);
INSERT INTO items VALUES(19, 60, TO_DATE('13-12-2001', 'dd-MM-yyyy'), '', 1336.65, 0);
INSERT INTO items VALUES(20, 160, TO_DATE('18-08-2012', 'dd-MM-yyyy'), '', 474.25, 0);
INSERT INTO items VALUES(21, 80, TO_DATE('27-01-2007', 'dd-MM-yyyy'), '', 2677.40, 0);
INSERT INTO items VALUES(22, 180, TO_DATE('15-08-2022', 'dd-MM-yyyy'), '', 218.95, 0);
INSERT INTO items VALUES(23, 250, TO_DATE('07-03-2015', 'dd-MM-yyyy'), '', 744.25, 0);
INSERT INTO items VALUES(24, 130, TO_DATE('18-04-2016', 'dd-MM-yyyy'), '', 829.40, 0);
INSERT INTO items VALUES(25, 220, TO_DATE('18-10-2006', 'dd-MM-yyyy'), '', 1737.55, 0);
INSERT INTO items VALUES(26, 250, TO_DATE('08-01-2003', 'dd-MM-yyyy'), '', 2838.10, 0);
INSERT INTO items VALUES(27, 60, TO_DATE('14-10-2014', 'dd-MM-yyyy'), '', 1665.30, 0);
INSERT INTO items VALUES(28, 10, TO_DATE('19-10-2015', 'dd-MM-yyyy'), '', 1575.15, 0);
INSERT INTO items VALUES(29, 100, TO_DATE('08-07-2022', 'dd-MM-yyyy'), '', 2959.0, 0);
INSERT INTO items VALUES(30, 200, TO_DATE('05-04-2007', 'dd-MM-yyyy'), '', 759.75, 0);
INSERT INTO items VALUES(31, 140, TO_DATE('10-07-2008', 'dd-MM-yyyy'), '', 1109.75, 0);
INSERT INTO items VALUES(32, 50, TO_DATE('16-09-2018', 'dd-MM-yyyy'), '', 1211.15, 0);
INSERT INTO items VALUES(33, 20, TO_DATE('10-11-2022', 'dd-MM-yyyy'), '', 2400.50, 0);
INSERT INTO items VALUES(34, 100, TO_DATE('14-05-2022', 'dd-MM-yyyy'), '', 1912.30, 0);
INSERT INTO items VALUES(35, 140, TO_DATE('13-06-2020', 'dd-MM-yyyy'), '', 367.45, 0);
INSERT INTO items VALUES(36, 10, TO_DATE('03-11-2005', 'dd-MM-yyyy'), '', 431.50, 0);
INSERT INTO items VALUES(37, 120, TO_DATE('15-08-2004', 'dd-MM-yyyy'), '', 1709.45, 0);
INSERT INTO items VALUES(38, 190, TO_DATE('09-10-2011', 'dd-MM-yyyy'), '', 445.5, 0);
INSERT INTO items VALUES(39, 130, TO_DATE('04-05-2015', 'dd-MM-yyyy'), '', 2329.35, 0);
INSERT INTO items VALUES(40, 20, TO_DATE('12-09-2016', 'dd-MM-yyyy'), '', 301.5, 0);
INSERT INTO items VALUES(41, 80, TO_DATE('25-08-2021', 'dd-MM-yyyy'), '', 1152.25, 0);
INSERT INTO items VALUES(42, 230, TO_DATE('09-10-2002', 'dd-MM-yyyy'), '', 1537.70, 0);
INSERT INTO items VALUES(43, 140, TO_DATE('11-07-2020', 'dd-MM-yyyy'), '', 148.20, 0);
INSERT INTO items VALUES(44, 200, TO_DATE('10-04-2020', 'dd-MM-yyyy'), '', 1955.75, 0);
INSERT INTO items VALUES(45, 120, TO_DATE('24-05-2005', 'dd-MM-yyyy'), '', 1959.0, 0);
INSERT INTO items VALUES(46, 70, TO_DATE('14-07-2001', 'dd-MM-yyyy'), '', 672.20, 0);
INSERT INTO items VALUES(47, 60, TO_DATE('12-01-2009', 'dd-MM-yyyy'), '', 683.90, 0);
INSERT INTO items VALUES(48, 180, TO_DATE('01-10-2007', 'dd-MM-yyyy'), '', 860.70, 0);
INSERT INTO items VALUES(49, 110, TO_DATE('11-01-2010', 'dd-MM-yyyy'), '', 1474.5, 0);
INSERT INTO items VALUES(50, 180, TO_DATE('27-12-2011', 'dd-MM-yyyy'), '', 1857.10, 0);
INSERT INTO items VALUES(51, 240, TO_DATE('10-11-2005', 'dd-MM-yyyy'), '', 1623.5, 0);
INSERT INTO items VALUES(52, 50, TO_DATE('22-03-2004', 'dd-MM-yyyy'), '', 590.80, 0);
INSERT INTO items VALUES(53, 150, TO_DATE('04-10-2004', 'dd-MM-yyyy'), '', 1324.0, 0);
INSERT INTO items VALUES(54, 160, TO_DATE('26-01-2018', 'dd-MM-yyyy'), '', 2660.50, 0);
INSERT INTO items VALUES(55, 80, TO_DATE('03-01-2011', 'dd-MM-yyyy'), '', 2220.15, 0);
INSERT INTO items VALUES(56, 90, TO_DATE('13-07-2002', 'dd-MM-yyyy'), '', 1195.30, 0);
INSERT INTO items VALUES(57, 150, TO_DATE('25-06-2007', 'dd-MM-yyyy'), '', 889.0, 0);
INSERT INTO items VALUES(58, 230, TO_DATE('05-06-2002', 'dd-MM-yyyy'), '', 54.40, 0);
INSERT INTO items VALUES(59, 180, TO_DATE('12-11-2010', 'dd-MM-yyyy'), '', 2678.30, 0);
INSERT INTO items VALUES(60, 110, TO_DATE('08-07-2019', 'dd-MM-yyyy'), '', 54.0, 0);
INSERT INTO items VALUES(61, 80, TO_DATE('17-07-2003', 'dd-MM-yyyy'), '', 149.5, 0);
INSERT INTO items VALUES(62, 40, TO_DATE('18-02-2022', 'dd-MM-yyyy'), '', 1873.20, 0);
INSERT INTO items VALUES(63, 260, TO_DATE('09-02-2003', 'dd-MM-yyyy'), '', 1550.40, 0);
INSERT INTO items VALUES(64, 140, TO_DATE('01-01-2000', 'dd-MM-yyyy'), '', 275.20, 0);
INSERT INTO items VALUES(65, 220, TO_DATE('03-10-2020', 'dd-MM-yyyy'), '', 411.25, 0);
INSERT INTO items VALUES(66, 110, TO_DATE('21-09-2021', 'dd-MM-yyyy'), '', 1630.0, 0);
INSERT INTO items VALUES(67, 240, TO_DATE('06-04-2022', 'dd-MM-yyyy'), '', 1513.55, 0);
INSERT INTO items VALUES(68, 90, TO_DATE('06-08-2002', 'dd-MM-yyyy'), '', 725.95, 0);
INSERT INTO items VALUES(69, 120, TO_DATE('09-03-2008', 'dd-MM-yyyy'), '', 1456.5, 0);
INSERT INTO items VALUES(70, 50, TO_DATE('02-02-2015', 'dd-MM-yyyy'), '', 2197.65, 0);
INSERT INTO items VALUES(71, 20, TO_DATE('03-07-2022', 'dd-MM-yyyy'), '', 1805.15, 0);
INSERT INTO items VALUES(72, 40, TO_DATE('06-11-2006', 'dd-MM-yyyy'), '', 933.5, 0);
INSERT INTO items VALUES(73, 130, TO_DATE('27-06-2012', 'dd-MM-yyyy'), '', 2006.0, 0);
INSERT INTO items VALUES(74, 160, TO_DATE('22-06-2017', 'dd-MM-yyyy'), '', 217.95, 0);
INSERT INTO items VALUES(75, 160, TO_DATE('24-03-2019', 'dd-MM-yyyy'), '', 393.60, 0);
INSERT INTO items VALUES(76, 90, TO_DATE('17-10-2002', 'dd-MM-yyyy'), '', 501.90, 0);
INSERT INTO items VALUES(77, 10, TO_DATE('11-02-2022', 'dd-MM-yyyy'), '', 810.5, 0);
INSERT INTO items VALUES(78, 20, TO_DATE('25-03-2022', 'dd-MM-yyyy'), '', 1940.20, 0);
INSERT INTO items VALUES(79, 130, TO_DATE('04-10-2001', 'dd-MM-yyyy'), '', 716.70, 0);
INSERT INTO items VALUES(80, 140, TO_DATE('16-11-2013', 'dd-MM-yyyy'), '', 2779.80, 0);
INSERT INTO items VALUES(81, 170, TO_DATE('25-07-2014', 'dd-MM-yyyy'), '', 1921.90, 0);
INSERT INTO items VALUES(82, 30, TO_DATE('26-12-2012', 'dd-MM-yyyy'), '', 1164.70, 0);
INSERT INTO items VALUES(83, 270, TO_DATE('21-05-2011', 'dd-MM-yyyy'), '', 2960.20, 0);
INSERT INTO items VALUES(84, 270, TO_DATE('22-08-2010', 'dd-MM-yyyy'), '', 2586.30, 0);
INSERT INTO items VALUES(85, 170, TO_DATE('22-03-2002', 'dd-MM-yyyy'), '', 2991.0, 0);
INSERT INTO items VALUES(86, 160, TO_DATE('05-04-2015', 'dd-MM-yyyy'), '', 535.95, 0);
INSERT INTO items VALUES(87, 80, TO_DATE('04-12-2003', 'dd-MM-yyyy'), '', 1413.20, 0);
INSERT INTO items VALUES(88, 160, TO_DATE('23-03-2016', 'dd-MM-yyyy'), '', 726.50, 0);
INSERT INTO items VALUES(89, 110, TO_DATE('15-04-2008', 'dd-MM-yyyy'), '', 1433.85, 0);
INSERT INTO items VALUES(90, 90, TO_DATE('24-02-2008', 'dd-MM-yyyy'), '', 1054.35, 0);
INSERT INTO items VALUES(91, 180, TO_DATE('12-02-2017', 'dd-MM-yyyy'), '', 2545.70, 0);
INSERT INTO items VALUES(92, 270, TO_DATE('15-04-2012', 'dd-MM-yyyy'), '', 2648.30, 0);
INSERT INTO items VALUES(93, 60, TO_DATE('09-06-2005', 'dd-MM-yyyy'), '', 1753.20, 0);
INSERT INTO items VALUES(94, 100, TO_DATE('05-12-2002', 'dd-MM-yyyy'), '', 2507.40, 0);
INSERT INTO items VALUES(95, 170, TO_DATE('11-01-2000', 'dd-MM-yyyy'), '', 1625.30, 0);
INSERT INTO items VALUES(96, 90, TO_DATE('01-10-2021', 'dd-MM-yyyy'), '', 118.20, 0);
INSERT INTO items VALUES(97, 130, TO_DATE('10-05-2013', 'dd-MM-yyyy'), '', 1656.60, 0);
INSERT INTO items VALUES(98, 50, TO_DATE('27-09-2009', 'dd-MM-yyyy'), '', 2272.60, 0);
INSERT INTO items VALUES(99, 140, TO_DATE('18-04-2020', 'dd-MM-yyyy'), '', 496.60, 0);
INSERT INTO items VALUES(100, 60, TO_DATE('21-04-2011', 'dd-MM-yyyy'), '', 1863.40, 0);

INSERT INTO customers VALUES(1, 'Mary', 'Marrero', 'mary_marrero@gmail.com', '+447700900095', 'Saltdean Close', 'JM', 1);
INSERT INTO customers VALUES(2, 'Robert', 'Robinson', 'robert_robinson@gmail.com', '+447700900750', 'Ffordd Las', 'WS', 1);
INSERT INTO customers VALUES(3, 'Nicole', 'Johnson', 'nicole_johnson@gmail.com', '+447700900865', 'North Side', 'AG', 1);
INSERT INTO customers VALUES(4, 'Joseph', 'Phillips', 'joseph_phillips@gmail.com', '+447700900276', 'Mint Walk', 'MT', 0);
INSERT INTO customers VALUES(5, 'Lauren', 'Gibbs', 'lauren_gibbs@gmail.com', '+447700900486', 'Caroline Street', 'EG', 0);
INSERT INTO customers VALUES(6, 'Stella', 'Cole', 'stella_cole@gmail.com', '+447700900709', 'Cumberland Place', 'SJ', 1);
INSERT INTO customers VALUES(7, 'Colleen', 'Swartz', 'colleen_swartz@gmail.com', '+447700900104', 'St Thomas''s Road', 'SB', 0);
INSERT INTO customers VALUES(8, 'Christopher', 'Kyle', 'christopher_kyle@gmail.com', '+447700900683', 'Rook Street', 'BJ', 1);
INSERT INTO customers VALUES(9, 'Robert', 'Waage', 'robert_waage@gmail.com', '+447700900603', 'Wagtail Way', 'CY', 0);
INSERT INTO customers VALUES(10, 'Glenda', 'Mckinsey', 'glenda_mckinsey@gmail.com', '+447700900498', 'Blackstone Avenue', 'CW', 1);
INSERT INTO customers VALUES(11, 'Herman', 'Carchi', 'herman_carchi@gmail.com', '+447700900731', 'Rawlings Court', 'DM', 1);
INSERT INTO customers VALUES(12, 'Winford', 'Culberson', 'winford_culberson@gmail.com', '+447700900377', 'Gundry Close', 'GT', 1);
INSERT INTO customers VALUES(13, 'Rose', 'Albright', 'rose_albright@gmail.com', '+447700900798', 'Nelson''s Lane', 'JP', 0);
INSERT INTO customers VALUES(14, 'Jillian', 'Kallam', 'jillian_kallam@gmail.com', '+447700900007', 'Crookham Close', 'UK', 0);
INSERT INTO customers VALUES(15, 'Renee', 'Schultz', 'renee_schultz@gmail.com', '+447700900612', 'Denton Way', 'MP', 0);
INSERT INTO customers VALUES(16, 'James', 'Molina', 'james_molina@gmail.com', '+447700900216', 'Deanery Road', 'MR', 1);
INSERT INTO customers VALUES(17, 'Marian', 'Benear', 'marian_benear@gmail.com', '+447700900799', 'Park View Terrace', 'CV', 1);
INSERT INTO customers VALUES(18, 'Rosemary', 'Williamston', 'rosemary_williamston@gmail.com', '+447700900178', 'Litton Close', 'TK', 0);
INSERT INTO customers VALUES(19, 'Luke', 'Jacobs', 'luke_jacobs@gmail.com', '+447700900149', 'Bishop Court', 'IE', 0);
INSERT INTO customers VALUES(20, 'Jamie', 'Smith', 'jamie_smith@gmail.com', '+447700900378', 'Scholes Road', 'AU', 0);
INSERT INTO customers VALUES(21, 'Carl', 'Allen', 'carl_allen@gmail.com', '+447700900190', 'Peterborough Drive', 'BV', 0);
INSERT INTO customers VALUES(22, 'Larry', 'Escalante', 'larry_escalante@gmail.com', '+447700900921', 'Archers Way', 'ER', 1);
INSERT INTO customers VALUES(23, 'Herbert', 'Gray', 'herbert_gray@gmail.com', '+447700900693', 'Bute Terrace', 'EG', 0);
INSERT INTO customers VALUES(24, 'Steven', 'Liscomb', 'steven_liscomb@gmail.com', '+447700900198', 'Holmbush Way', 'MX', 0);
INSERT INTO customers VALUES(25, 'Keith', 'Zelaya', 'keith_zelaya@gmail.com', '+447700900300', 'Mere View', 'AQ', 0);
INSERT INTO customers VALUES(26, 'Krista', 'Steese', 'krista_steese@gmail.com', '+447700900761', 'Benenden Road', 'EG', 0);
INSERT INTO customers VALUES(27, 'David', 'Lenderman', 'david_lenderman@gmail.com', '+447700900749', 'Moorlands Crescent', 'QA', 1);
INSERT INTO customers VALUES(28, 'Walter', 'Booker', 'walter_booker@gmail.com', '+447700900118', 'Crucible Close', 'QA', 1);
INSERT INTO customers VALUES(29, 'Carl', 'Travis', 'carl_travis@gmail.com', '+447700900941', 'Symonds Road', 'FI', 1);
INSERT INTO customers VALUES(30, 'Mildred', 'Eaton', 'mildred_eaton@gmail.com', '+447700900373', 'Marwood Drive', 'UM', 1);
INSERT INTO customers VALUES(31, 'Donald', 'Eichorn', 'donald_eichorn@gmail.com', '+447700900857', 'Glenfield Road', 'KM', 0);
INSERT INTO customers VALUES(32, 'Richard', 'Grev', 'richard_grev@gmail.com', '+447700900317', 'Ethel Street', 'MK', 0);
INSERT INTO customers VALUES(33, 'Frankie', 'Tiger', 'frankie_tiger@gmail.com', '+447700900936', 'Langtree Close', 'TM', 0);
INSERT INTO customers VALUES(34, 'Maria', 'Burns', 'maria_burns@gmail.com', '+447700900109', 'Forfar Road', 'PF', 1);
INSERT INTO customers VALUES(35, 'Wendell', 'Lackey', 'wendell_lackey@gmail.com', '+447700900726', 'Darley Drive', 'KR', 1);
INSERT INTO customers VALUES(36, 'Geraldine', 'Walters', 'geraldine_walters@gmail.com', '+447700900199', 'Penrhiw Road', 'KP', 0);
INSERT INTO customers VALUES(37, 'Jada', 'Helton', 'jada_helton@gmail.com', '+447700900124', 'Kingsfield Court', 'IE', 0);
INSERT INTO customers VALUES(38, 'Mary', 'Egger', 'mary_egger@gmail.com', '+447700900126', 'Croftwood', 'BM', 0);
INSERT INTO customers VALUES(39, 'Hal', 'Boyle', 'hal_boyle@gmail.com', '+447700900828', 'Minter Close', 'RU', 0);
INSERT INTO customers VALUES(40, 'Minnie', 'Hall', 'minnie_hall@gmail.com', '+447700900529', 'Bramber Road', 'RU', 0);

INSERT INTO orders VALUES(1, TO_DATE('07-07-2021', 'dd-MM-yyyy'), TO_DATE('18-08-2021', 'dd-MM-yyyy'), 29, NULL, NULL);
INSERT INTO orders VALUES(2, TO_DATE('15-01-2020', 'dd-MM-yyyy'), TO_DATE('21-02-2020', 'dd-MM-yyyy'), 30, NULL, NULL);
INSERT INTO orders VALUES(3, TO_DATE('20-12-2022', 'dd-MM-yyyy'), TO_DATE('04-01-2023', 'dd-MM-yyyy'), 28, NULL, NULL);
INSERT INTO orders VALUES(4, TO_DATE('05-05-2020', 'dd-MM-yyyy'), TO_DATE('20-06-2020', 'dd-MM-yyyy'), 2, NULL, NULL);
INSERT INTO orders VALUES(5, TO_DATE('13-10-2021', 'dd-MM-yyyy'), TO_DATE('08-11-2021', 'dd-MM-yyyy'), 24, NULL, NULL);
INSERT INTO orders VALUES(6, TO_DATE('25-11-2022', 'dd-MM-yyyy'), TO_DATE('20-12-2022', 'dd-MM-yyyy'), 17, NULL, NULL);
INSERT INTO orders VALUES(7, TO_DATE('27-03-2021', 'dd-MM-yyyy'), TO_DATE('21-04-2021', 'dd-MM-yyyy'), 2, NULL, NULL);
INSERT INTO orders VALUES(8, TO_DATE('07-04-2018', 'dd-MM-yyyy'), TO_DATE('22-05-2018', 'dd-MM-yyyy'), 13, NULL, NULL);
INSERT INTO orders VALUES(9, TO_DATE('14-03-2021', 'dd-MM-yyyy'), TO_DATE('26-04-2021', 'dd-MM-yyyy'), 20, NULL, NULL);
INSERT INTO orders VALUES(10, TO_DATE('09-03-2020', 'dd-MM-yyyy'), TO_DATE('19-04-2020', 'dd-MM-yyyy'), 25, NULL, NULL);
INSERT INTO orders VALUES(11, TO_DATE('27-09-2021', 'dd-MM-yyyy'), TO_DATE('18-10-2021', 'dd-MM-yyyy'), 2, NULL, NULL);
INSERT INTO orders VALUES(12, TO_DATE('01-04-2020', 'dd-MM-yyyy'), TO_DATE('21-05-2020', 'dd-MM-yyyy'), 35, NULL, NULL);
INSERT INTO orders VALUES(13, TO_DATE('12-07-2020', 'dd-MM-yyyy'), TO_DATE('01-08-2020', 'dd-MM-yyyy'), 11, NULL, NULL);
INSERT INTO orders VALUES(14, TO_DATE('01-10-2022', 'dd-MM-yyyy'), TO_DATE('26-11-2022', 'dd-MM-yyyy'), 38, NULL, NULL);
INSERT INTO orders VALUES(15, TO_DATE('15-10-2019', 'dd-MM-yyyy'), TO_DATE('12-11-2019', 'dd-MM-yyyy'), 37, NULL, NULL);
INSERT INTO orders VALUES(16, TO_DATE('01-11-2018', 'dd-MM-yyyy'), TO_DATE('12-12-2018', 'dd-MM-yyyy'), 33, NULL, NULL);
INSERT INTO orders VALUES(17, TO_DATE('13-03-2018', 'dd-MM-yyyy'), TO_DATE('23-04-2018', 'dd-MM-yyyy'), 38, NULL, NULL);
INSERT INTO orders VALUES(18, TO_DATE('05-03-2022', 'dd-MM-yyyy'), TO_DATE('01-04-2022', 'dd-MM-yyyy'), 37, NULL, NULL);
INSERT INTO orders VALUES(19, TO_DATE('03-08-2020', 'dd-MM-yyyy'), TO_DATE('03-09-2020', 'dd-MM-yyyy'), 36, NULL, NULL);
INSERT INTO orders VALUES(20, TO_DATE('02-09-2020', 'dd-MM-yyyy'), TO_DATE('20-10-2020', 'dd-MM-yyyy'), 39, NULL, NULL);
INSERT INTO orders VALUES(21, TO_DATE('12-10-2022', 'dd-MM-yyyy'), TO_DATE('06-11-2022', 'dd-MM-yyyy'), 24, NULL, NULL);
INSERT INTO orders VALUES(22, TO_DATE('02-04-2018', 'dd-MM-yyyy'), TO_DATE('03-05-2018', 'dd-MM-yyyy'), 7, NULL, NULL);
INSERT INTO orders VALUES(23, TO_DATE('04-11-2018', 'dd-MM-yyyy'), TO_DATE('04-12-2018', 'dd-MM-yyyy'), 37, NULL, NULL);
INSERT INTO orders VALUES(24, TO_DATE('26-08-2020', 'dd-MM-yyyy'), TO_DATE('22-09-2020', 'dd-MM-yyyy'), 28, NULL, NULL);
INSERT INTO orders VALUES(25, TO_DATE('01-07-2018', 'dd-MM-yyyy'), TO_DATE('03-08-2018', 'dd-MM-yyyy'), 22, NULL, NULL);
INSERT INTO orders VALUES(26, TO_DATE('02-12-2020', 'dd-MM-yyyy'), TO_DATE('07-01-2021', 'dd-MM-yyyy'), 19, NULL, NULL);
INSERT INTO orders VALUES(27, TO_DATE('09-01-2021', 'dd-MM-yyyy'), TO_DATE('20-02-2021', 'dd-MM-yyyy'), 19, NULL, NULL);
INSERT INTO orders VALUES(28, TO_DATE('04-07-2022', 'dd-MM-yyyy'), TO_DATE('02-08-2022', 'dd-MM-yyyy'), 18, NULL, NULL);
INSERT INTO orders VALUES(29, TO_DATE('04-11-2018', 'dd-MM-yyyy'), TO_DATE('23-12-2018', 'dd-MM-yyyy'), 1, NULL, NULL);
INSERT INTO orders VALUES(30, TO_DATE('26-08-2022', 'dd-MM-yyyy'), TO_DATE('27-09-2022', 'dd-MM-yyyy'), 39, NULL, NULL);

INSERT INTO ordered_items VALUES(1, 13, 1);
INSERT INTO ordered_items VALUES(2, 57, 1);
INSERT INTO ordered_items VALUES(3, 62, 1);
INSERT INTO ordered_items VALUES(4, 71, 2);
INSERT INTO ordered_items VALUES(5, 69, 2);
INSERT INTO ordered_items VALUES(6, 70, 3);
INSERT INTO ordered_items VALUES(7, 84, 3);
INSERT INTO ordered_items VALUES(8, 99, 4);
INSERT INTO ordered_items VALUES(9, 86, 4);
INSERT INTO ordered_items VALUES(10, 21, 4);
INSERT INTO ordered_items VALUES(11, 82, 4);
INSERT INTO ordered_items VALUES(12, 92, 5);
INSERT INTO ordered_items VALUES(13, 51, 5);
INSERT INTO ordered_items VALUES(14, 17, 5);
INSERT INTO ordered_items VALUES(15, 81, 5);
INSERT INTO ordered_items VALUES(16, 56, 6);
INSERT INTO ordered_items VALUES(17, 88, 6);
INSERT INTO ordered_items VALUES(18, 75, 7);
INSERT INTO ordered_items VALUES(19, 20, 7);
INSERT INTO ordered_items VALUES(20, 45, 7);
INSERT INTO ordered_items VALUES(21, 6, 7);
INSERT INTO ordered_items VALUES(22, 48, 8);
INSERT INTO ordered_items VALUES(23, 55, 8);
INSERT INTO ordered_items VALUES(24, 10, 8);
INSERT INTO ordered_items VALUES(25, 9, 9);
INSERT INTO ordered_items VALUES(26, 32, 9);
INSERT INTO ordered_items VALUES(27, 38, 9);
INSERT INTO ordered_items VALUES(28, 96, 10);
INSERT INTO ordered_items VALUES(29, 19, 10);
INSERT INTO ordered_items VALUES(30, 18, 10);
INSERT INTO ordered_items VALUES(31, 22, 11);
INSERT INTO ordered_items VALUES(32, 23, 11);
INSERT INTO ordered_items VALUES(33, 49, 12);
INSERT INTO ordered_items VALUES(34, 26, 12);
INSERT INTO ordered_items VALUES(35, 77, 12);
INSERT INTO ordered_items VALUES(36, 43, 12);
INSERT INTO ordered_items VALUES(37, 95, 13);
INSERT INTO ordered_items VALUES(38, 67, 14);
INSERT INTO ordered_items VALUES(39, 4, 15);
INSERT INTO ordered_items VALUES(40, 90, 15);
INSERT INTO ordered_items VALUES(41, 59, 16);
INSERT INTO ordered_items VALUES(42, 8, 16);
INSERT INTO ordered_items VALUES(43, 35, 16);
INSERT INTO ordered_items VALUES(44, 94, 16);
INSERT INTO ordered_items VALUES(45, 91, 17);
INSERT INTO ordered_items VALUES(46, 79, 17);
INSERT INTO ordered_items VALUES(47, 65, 17);
INSERT INTO ordered_items VALUES(48, 73, 17);
INSERT INTO ordered_items VALUES(49, 7, 18);
INSERT INTO ordered_items VALUES(50, 2, 18);
INSERT INTO ordered_items VALUES(51, 52, 18);
INSERT INTO ordered_items VALUES(52, 58, 19);
INSERT INTO ordered_items VALUES(53, 50, 20);
INSERT INTO ordered_items VALUES(54, 89, 21);
INSERT INTO ordered_items VALUES(55, 46, 21);
INSERT INTO ordered_items VALUES(56, 68, 22);
INSERT INTO ordered_items VALUES(57, 47, 22);
INSERT INTO ordered_items VALUES(58, 31, 22);
INSERT INTO ordered_items VALUES(59, 30, 22);
INSERT INTO ordered_items VALUES(60, 80, 23);
INSERT INTO ordered_items VALUES(61, 97, 23);
INSERT INTO ordered_items VALUES(62, 98, 23);
INSERT INTO ordered_items VALUES(63, 12, 24);
INSERT INTO ordered_items VALUES(64, 44, 25);
INSERT INTO ordered_items VALUES(65, 1, 25);
INSERT INTO ordered_items VALUES(66, 11, 26);
INSERT INTO ordered_items VALUES(67, 15, 26);
INSERT INTO ordered_items VALUES(68, 78, 26);
INSERT INTO ordered_items VALUES(69, 28, 27);
INSERT INTO ordered_items VALUES(70, 85, 27);
INSERT INTO ordered_items VALUES(71, 33, 27);
INSERT INTO ordered_items VALUES(72, 74, 27);
INSERT INTO ordered_items VALUES(73, 72, 28);
INSERT INTO ordered_items VALUES(74, 83, 28);
INSERT INTO ordered_items VALUES(75, 63, 28);
INSERT INTO ordered_items VALUES(76, 64, 28);
INSERT INTO ordered_items VALUES(77, 37, 29);
INSERT INTO ordered_items VALUES(78, 34, 30);
INSERT INTO ordered_items VALUES(79, 25, 30);
INSERT INTO ordered_items VALUES(80, 41, 30);

CREATE INDEX customer_name_ix ON customers(first_name, last_name);
CREATE INDEX customer_country ON customers(country_id);
CREATE INDEX manufacturer_country_ix ON manufacturers(country_id);
CREATE INDEX instrument_name_ix ON instruments(instrument_name);

CREATE TABLE favorite_manufacturers(
    full_name varchar2(50)
    ,manufacturer_name varchar2(30)
);

CREATE TABLE names_and_pays(
    full_name varchar2(50),
    paid NUMBER(7,2)
);

COMMENT ON TABLE favorite_manufacturers IS 'Auxiliary table used for get_favorite_manufacturers procedure';
COMMENT ON TABLE names_and_pays IS 'Auxiliary table used for get_most_expensive_orders procedure';

COMMIT;


