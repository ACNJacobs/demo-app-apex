-- Fix SCAFF_LANGUAGE LOV display values on MaxApex
-- Run this in APEX Builder > SQL Workshop > SQL Commands

BEGIN
  -- Update each LOV entry to remove &{} syntax
  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Nederlands'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'nl';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'English'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'en';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Français'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'fr';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Deutsch'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'de';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Polski'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'pl';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Русский'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'ru';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'العربية'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'ar';

  UPDATE wwv_flow_list_of_values_data
  SET display_value = 'Türkçe'
  WHERE lov_id = (SELECT lov_id FROM wwv_flow_list_of_values WHERE application_id = 100 AND list_of_values_name = 'SCAFF_LANGUAGE')
    AND return_value = 'tr';

  COMMIT;
END;
/
