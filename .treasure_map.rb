map_for(:configatron) do |nachos|
  # nachos.watch "dir1", "dir2"
  
  test_type = "spec" # or even just "test_type = 'test' or 'example' or 'spec' ??
  
	nachos.keep_a_watchful_eye_for "app", "spec"
 
  nachos.prepare_spell_for %r%^lib/(.*)\.rb% do |match|
    ["#{test_type}/#{match[1]}_#{test_type}.rb"]
  end
  
  nachos.prepare_spell_for %r%^#{test_type}/(.*)_#{test_type}\.rb% do |match|
  p match[1]
  p match[0]
    ["#{test_type}/#{match[1]}_#{test_type}.rb"]
  end
  
  nachos.prepare_spell_for %r%^#{test_type}/#{test_type}_helper\.rb% do |spell_component|
    Dir["#{test_type}/**/*_#{test_type}.rb"]
  end
  
end