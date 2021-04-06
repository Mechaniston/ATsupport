﻿
&НаКлиенте
Процедура РедактированиеПриИзменении(Элемент)
	
	Если Запись.Редактирование Тогда
		Запись.Просмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвязиПараметровВыбораПользователя()
	
	Если ЗначениеЗаполнено(Запись.Клиент) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СпецификацияПользователей_ат.Пользователь
		|ИЗ
		|	РегистрСведений.СпецификацияПользователей_ат КАК СпецификацияПользователей_ат
		|ГДЕ
		|	СпецификацияПользователей_ат.Контрагент = &Контрагент";
		Запрос.УстановитьПараметр("Контрагент", Запись.Клиент);
		
		ПользователиПоКлиенту.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь"));
		
		НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Ссылка", "ПользователиПоКлиенту");
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НоваяСвязь);
		НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.Пользователь.СвязиПараметровВыбора = НовыеСвязи;
		
	Иначе
		
		Элементы.Пользователь.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	
	ЗаполнитьСвязиПараметровВыбораПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрПриИзменении(Элемент)
	
	Если НЕ Запись.Просмотр Тогда
		Запись.Редактирование = Ложь;
	КонецЕсли;
	
КонецПроцедуры
