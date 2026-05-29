set define off

prompt === seed extra IO + PO/N dummy data (idempotent) ===

merge into scaff_po t
using (
  select 'IO/'  as po_prefix, '00047' as po_number, 'SCAFF - Intern depot Genk'            as customer_name, 'Henry Fordlaan 12'                 as address_line, '3600' as postal_code, 'GENK'      as city from dual union all
  select 'IO/'  as po_prefix, '00048' as po_number, 'SCAFF - Intern depot Gent'            as customer_name, 'Skaldenstraat 125'                as address_line, '9042' as postal_code, 'GENT'      as city from dual union all
  select 'IO/'  as po_prefix, '00049' as po_number, 'SCAFF - Intern depot Charleroi'       as customer_name, 'Rue de Monceau Fontaine 40'       as address_line, '6031' as postal_code, 'CHARLEROI' as city from dual union all
  select 'IO/'  as po_prefix, '00050' as po_number, 'SCAFF - Intern depot Breda'           as customer_name, 'Konijnenberg 130'                 as address_line, '4825' as postal_code, 'BREDA'     as city from dual union all
  select 'IO/'  as po_prefix, '00051' as po_number, 'SCAFF - Intern depot Rotterdam'       as customer_name, 'Waalhaven Zuidzijde 20'           as address_line, '3088' as postal_code, 'ROTTERDAM' as city from dual union all
  select 'PO/N' as po_prefix, '00013' as po_number, 'SCAFF - Nieuwe klant Kortrijk'        as customer_name, 'Beneluxpark 22'                   as address_line, '8500' as postal_code, 'KORTRIJK'  as city from dual union all
  select 'PO/N' as po_prefix, '00014' as po_number, 'SCAFF - Nieuwe klant Antwerpen Noord' as customer_name, 'Noorderlaan 501'                  as address_line, '2030' as postal_code, 'ANTWERPEN' as city from dual union all
  select 'PO/N' as po_prefix, '00015' as po_number, 'SCAFF - Nieuwe klant Eindhoven'       as customer_name, 'Flight Forum 2100'                as address_line, '5657' as postal_code, 'EINDHOVEN' as city from dual union all
  select 'PO/N' as po_prefix, '00016' as po_number, 'SCAFF - Nieuwe klant Hasselt'         as customer_name, 'Gouverneur Verwilghensingel 2'    as address_line, '3500' as postal_code, 'HASSELT'   as city from dual union all
  select 'PO/N' as po_prefix, '00017' as po_number, 'SCAFF - Nieuwe klant Utrecht'         as customer_name, 'Papendorpseweg 100'               as address_line, '3528' as postal_code, 'UTRECHT'   as city from dual
) s
on (t.po_prefix = s.po_prefix and t.po_number = s.po_number)
when not matched then
  insert (po_prefix, po_number, customer_name, address_line, postal_code, city)
  values (s.po_prefix, s.po_number, s.customer_name, s.address_line, s.postal_code, s.city);

commit;

prompt === prefix counts ===
select po_prefix, count(*) as cnt
  from scaff_po
 group by po_prefix
 order by po_prefix;
