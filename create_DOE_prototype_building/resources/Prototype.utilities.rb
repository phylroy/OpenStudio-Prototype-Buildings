
#load a model into OS & version translates, exiting and erroring if a problem is found
def safe_load_model(model_path_string)  
  model_path = OpenStudio::Path.new(model_path_string)
  if OpenStudio::exists(model_path)
    versionTranslator = OpenStudio::OSVersion::VersionTranslator.new 
    model = versionTranslator.loadModel(model_path)
    if model.empty?
      OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "Version translation failed for #{model_path_string}")
      return false
    else
      model = model.get
    end
  else
    OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "#{model_path_string} couldn't be found")
    return false
  end
  return model
end

#load a sql file, exiting and erroring if a problem is found
def safe_load_sql(sql_path_string)
  sql_path = OpenStudio::Path.new(sql_path_string)
  if OpenStudio::exists(sql_path)
    sql = OpenStudio::SqlFile.new(sql_path)
  else
    OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "#{sql_path} couldn't be found")
    return false
  end
  return sql
end

def strip_model(model)


  #remove all materials
  model.getMaterials.each do |mat|
    mat.remove
  end

  #remove all constructions
  model.getConstructions.each do |constr|
    constr.remove
  end

  #remove performance curves
  model.getCurves.each do |curve|
    curve.remove
  end

  #remove all zone equipment
  model.getThermalZones.each do |zone|
    zone.equipment.each do |equip|
      equip.remove
    end
  end
    
  #remove all thermostats
  model.getThermostatSetpointDualSetpoints.each do |tstat|
    tstat.remove
  end

  #remove all people
  model.getPeoples.each do |people|
    people.remove
  end
  model.getPeopleDefinitions.each do |people_def|
    people_def.remove
  end

  #remove all lights
  model.getLightss.each do |lights|
   lights.remove
  end
  model.getLightsDefinitions.each do |lights_def|
   lights_def.remove
  end

  #remove all electric equipment
  model.getElectricEquipments.each do |equip|
    equip.remove
  end
  model.getElectricEquipmentDefinitions.each do |equip_def|
    equip_def.remove
  end

  #remove all gas equipment
  model.getGasEquipments.each do |equip|
    equip.remove
  end
  model.getGasEquipmentDefinitions.each do |equip_def|
    equip_def.remove
  end

  #remove all outdoor air
  model.getDesignSpecificationOutdoorAirs.each do |oa_spec|
    oa_spec.remove
  end

  #remove all infiltration
  model.getSpaceInfiltrationDesignFlowRates.each do |infil|
    infil.remove
  end

  # Remove all internal mass
  model.getInternalMasss.each do |tm|
    tm.remove
  end

  # Remove all internal mass defs
  model.getInternalMassDefinitions.each do |tmd|
    tmd.remove
  end
  
  # Remove all thermal zones
  model.getThermalZones.each do |zone|
    zone.remove
  end
  
  # Remove all schedules
  model.getSchedules.each do |sch|
    sch.remove
  end
  
  # Remove all schedule type limits
  model.getScheduleTypeLimitss.each do |typ_lim|
    typ_lim.remove
  end
  
  # Remove the sizing parameters
  model.getSizingParameters.remove
  
  # Remove the design days
  model.getDesignDays.each do |dd|
    dd.remove
  end

  # Remove the rendering colors
  model.getRenderingColors.each do |rc|
    rc.remove
  end
  
  # Remove the daylight controls
  model.getDaylightingControls.each do |dc|
    dc.remove
  end
  
  return model


end

# A helper method to convert from SEER to COP
# per the method specified in "Achieving the 30% Goal: Energy 
# and cost savings analysis of ASHRAE Standard 90.1-2010
# Thornton, et al 2011
def seer_to_cop(seer)
  
  cop = nil

  # First convert from SEER to EER
  eer = (-0.0182 * seer * seer) + (1.1088 * seer)
  
  # Next convert EER to COP
  cop = eer_to_cop(eer)
  
  return cop
 
end

# A helper method to convert from EER to COP
# per the method specified in "Achieving the 30% Goal: Energy 
# and cost savings analysis of ASHRAE Standard 90.1-2010
# Thornton, et al 2011
def eer_to_cop(eer)
  
  cop = nil

  # r is the ratio of supply fan power to total equipment power at the rating condition,
  # assumed to be 0.12 for the reference buildngs per PNNL.
  r = 0.12
  
  cop = (eer/3.413 + r)/(1-r)
  
  return cop
 
end

# A helper method to convert from COP to kW/ton
def cop_to_kw_per_ton(cop)
  
  return 3.517/cop
 
end

# A helper method to convert from kW/ton to COP
def kw_per_ton_to_cop(kw_per_ton)
  
  return 3.517/kw_per_ton
 
end

# A helper method to convert from AFUE to thermal efficiency
def afue_to_thermal_eff(afue)
  
  return afue # Per PNNL doc, Boiler Addendum 90.1-04an
 
end

# A helper method to convert from combustion efficiency to thermal efficiency
def combustion_eff_to_thermal_eff(combustion_eff)
  
  return combustion_eff - 0.007 # Per PNNL doc, Boiler Addendum 90.1-04an
 
end

