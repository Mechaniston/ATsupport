﻿

Перем WINInfo, WINInfoOS, WinMGMT, Win32_OperatingSystem, OperatingSystem;




#Область Управление
#Область Пульт


&НаКлиенте
Процедура СтопСервера(ВС)
	Если Сервер.Пустая() тогда 
		Сообщение = новый СообщениеПользователю;
		Сообщение.Поле = "ЭтаФорма.Сервер1";

		Сообщение.Текст ="необходимо выбрать ВАШ сервер, которым вы хотите управлять";
		Сообщение.Сообщить();
	Иначе
		ПУДействие("stop ",ВС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартСервера(ВС)
	Если Сервер.Пустая() тогда 
		Сообщение = новый СообщениеПользователю;
		Сообщение.Поле = "ЭтаФорма.Сервер1";
		Сообщение.Текст ="необходимо выбрать ВАШ сервер, которым вы хотите управлять";
		Сообщение.Сообщить();
	Иначе
		ПУДействие("start ",ВС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РестартСервера(ВС)
	Если Сервер.Пустая() тогда 
		Сообщение = новый СообщениеПользователю;
		Сообщение.Поле = "ЭтаФорма.Сервер1";
		Сообщение.Текст ="необходимо выбрать ВАШ сервер, которым вы хотите управлять";
		Сообщение.Сообщить();
	Иначе
		ПУДействие("stop ",ВС);
		ПУДействие("start ",ВС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПУДействие(Действие,ВС)
	
	// Вставить содержимое обработчика.
	//Действие = "stop ";
	ИмяФайлаRUN = Константы.ПутьКТемпVZ_ат.Получить() + "run_" + ВС.ФизическийСервер.Наименование + "_" + СтрЗаменить(ВС.VEID,Символы.НПП,"") + ".bat";
	ИмяЛогаRUN  = Константы.ПутьКТемпVZ_ат.Получить() + "run_" + ВС.ФизическийСервер.Наименование + "_" + СтрЗаменить(ВС.VEID,Символы.НПП,"") + ".log";
	Парам = """cmd.exe"" ""/C cls| vzctl "  + Действие + СтрЗаменить(ВС.VEID,Символы.НПП,"") + Символ(34);
	СтрКом 	= Константы.ПутьКPSTools_ат.Получить() + "PsExec.exe \\" +  СтрЗаменить(ВС.ФизическийСервер.IPv4, " ","") + " -u " + ВС.ФизическийСервер.login + " -p " + ВС.ФизическийСервер.Password + " " + Парам;	
	
	RUN = ВыполнениеСОбработкойОшибок(СтрКом,ИмяФайлаRUN,ИмяЛогаRUN,ВС);
	
КонецФункции




&НаКлиенте
Процедура Настроить(Команда)
	НастройкаНаСервере();
КонецПроцедуры

//&НаКлиенте
//Процедура ВыделенныйСервер2ПриИзменении(Элемент)
//	Изменить = ложь;
//	Элементы.Изменить.ТолькоПросмотр = ложь;
//	ВыделенныйСервер2ПриИзмененииНаСервере();
//КонецПроцедуры

&НаКлиенте
Процедура изменитьПриИзменении()
	//изменитьПриИзмененииНаСервере();
	Сообщить("Данные буду могут оставаться изменёнными, пока не будут записаны все изменения на сервере. снятие этой галочки без применения, сбросит все изменения ");

	Если Изменить = ложь тогда
		Элементы.ГруппаСеть.ТолькоПросмотр = истина;
		Элементы.ГруппаРесурсы.ТолькоПросмотр = истина;
		Элементы.ГруппаДоп.ТолькоПросмотр = истина;
		//Элементы.изменить.ТолькоПросмотр = истина;
		ОбновитьИнтерфейс();
	Иначе
		Элементы.ГруппаСеть.ТолькоПросмотр = ложь;
		Элементы.ГруппаРесурсы.ТолькоПросмотр = ложь;
		Элементы.ГруппаДоп.ТолькоПросмотр = ложь;
		//Элементы.изменить.ТолькоПросмотр = ложь;
		
		ОбновитьИнтерфейс();
		
	КонецЕсли;
	//ВыделенныйСервер2ПриИзмененииНаСервере();

КонецПроцедуры



&НаСервере
Процедура НастройкаНаСервере()
// HARDCODED 
// данная процедура устарела! ее нужно менять!
	
	//ВС = ВыделенныйСервер;	
	ВС = Сервер;
	//настройка
	//ИмяФайлаНастройка = Константы.ПутьКТемпVZ_ат.Получить() + "prop_" + ВС.ФизическийСервер.Наименование + "_" + СтрЗаменить(ВС.VEID,Символы.НПП,"") + ".bat";
	//ИмяЛогаНастройка   = Константы.ПутьКТемпVZ_ат.Получить() + "prop_" + ВС.ФизическийСервер.Наименование + "_" + СтрЗаменить(ВС.VEID,Символы.НПП,"") + ".rez";
	
	Если АвтоЗапуск = Истина тогда 
		boot = " --onboot yes";
	Иначе
		boot = " --onboot no";
	КонецЕсли;
	
	//если ПустаяСтрока(IPv4) тогда 
	Если ПустаяСтрока(IPv4) или ПустаяСтрока(mask) тогда
	Сообщить("неверно заданы параметры сети, сервер возможно будет создан, но подключение к нему не созможно!");	
	Иначе
		
		
	КонецЕсли;
	парам0 = " --hostname "  + ВС.Наименование + " --description " + Символ(34) +"There could have our ads" +Символ(34) + " --name " + ВС.Наименование;
	парам1 = " --numproc " + numproc + " --cpus " + Core; 
	парам2 = " --vprvmem " + СтрЗаменить(RAM*1024,Символы.НПП,"") + " --diskspace " + СтрЗаменить(HDD*1024*1024,Символы.НПП,"") + boot;
	
	Если ПустаяСтрока(IPv4) или ПустаяСтрока(mask) тогда
		парам3 ="";	
	Иначе
		парам3 = " --ipadd " + СтрЗаменить(IPv4," ","");
		//+":"+ СтрЗаменить(mask," ","");	
	КонецЕсли;
	
	Если ПустаяСтрока(dns) и ПустаяСтрока(dns2) тогда
		парам4 ="";	
	Иначе
		парам4 = " --nameserver " + СтрЗаменить(dns," ","") +" "+ СтрЗаменить(dns2," ","");	
	КонецЕсли;

	Если ПустаяСтрока(Password) тогда
		парам5 = "";
	Иначе
		парам5 = " --userpasswd :" + Password;
		
	КонецЕсли;
	
	//КомНастройка = """cmd.exe"" ""/C cls| vzctl set " + СтрЗаменить(ВС.VEID,Символы.НПП,"") + парам0 + парам1 + парам2 + парам3 + парам4+парам5+ " --save" + Символ(34);
	//СтрКомНастройка = Константы.ПутьКPSTools_ат.Получить() + "PsExec.exe \\" +  СтрЗаменить(ВС.ФизическийСервер.IPv4, " ","") + " -u " + ВС.ФизическийСервер.login + " -p " + ВС.ФизическийСервер.Password + " " + КомНастройка;
	
	Настройка = Ложь;//ВыполнениеСОбработкойОшибок(СтрКомНастройка,ИмяФайлаНастройка,ИмяЛогаНастройка,ВС);
	Если Настройка = Истина тогда
		ПУДействие("stop ",ВС);
		ПУДействие("start ",ВС);
		
		Если изменить = истина тогда
			//попытка
				
				//ЗаписьВРегистр = РегистрыСведений.ВыделенныеСерверы_ат.СоздатьНаборЗаписей();
				//ЗаписьВРегистр.Отбор.ВыделенныйСервер.Установить(ВС);
				//// ресурсы
				//Ядро = ЗаписьВРегистр.Добавить();
				//Ядро.ВыделенныйСервер = ВС;
				//Ядро.Параметр = Перечисления.ТипыРесурсов_ат.Core;
				//Ядро.Значение = Core;   
				//
				//HD = ЗаписьВРегистр.Добавить();
				//HD.ВыделенныйСервер = ВС;
				//HD.Параметр = Перечисления.ТипыРесурсов_ат.HDD_ат;
				//HD.Значение = СтрЗаменить(HDD,символы.НПП,"");
				//
				//Память = ЗаписьВРегистр.Добавить();
				//Память.ВыделенныйСервер = ВС;
				//Память.Параметр = Перечисления.ТипыРесурсов_ат.RAM;
				//Память.Значение = СтрЗаменить(RAM,символы.НПП,"");
				//
				//

				//
				//// настройки сети
				//IP = ЗаписьВРегистр.Добавить();
				//IP.ВыделенныйСервер = ВС;
				//IP.Параметр = Перечисления.ТипыРесурсов_ат.IPv4;
				//IP.Значение = IPv4;
				//
				//mk = ЗаписьВРегистр.Добавить();
				//mk.ВыделенныйСервер = ВС;
				//mk.Параметр = Перечисления.ТипыРесурсов_ат.mask;
				//mk.Значение = Mask;
				//
				//GT = ЗаписьВРегистр.Добавить();
				//GT.ВыделенныйСервер = ВС;
				//GT.Параметр = Перечисления.ТипыРесурсов_ат.gate;
				//GT.Значение = gate;
				//
				//dn = ЗаписьВРегистр.Добавить();
				//dn.ВыделенныйСервер = ВС;
				//dn.Параметр = Перечисления.ТипыРесурсов_ат.dns;
				//dn.Значение = DNS;
				//
				//dn2 = ЗаписьВРегистр.Добавить();
				//dn2.ВыделенныйСервер = ВС;
				//dn2.Параметр = Перечисления.ТипыРесурсов_ат.dns2;
				//dn2.Значение = DNS2;
				//
				//
				//// параметры
				//proc = ЗаписьВРегистр.Добавить();
				//proc.ВыделенныйСервер = ВС;
				//proc.Параметр = Перечисления.ТипыРесурсов_ат.numproc;
				//proc.Значение = numproc;
				//
				////Зап = ЗаписьВРегистр.Добавить();
				////Зап.ВыделенныйСервер = Объект.Ссылка;
				////Зап.Параметр = Перечисления.ТипыРесурсов_ат.AdmPass;
				////Зап.Значение = ПарольАдмина;
				//
				//au = ЗаписьВРегистр.Добавить();
				//au.ВыделенныйСервер = ВС;
				//au.Параметр = Перечисления.ТипыРесурсов_ат.autostart;
				//au.Значение = АвтоЗапуск;

				//
				////pas = ЗаписьВРегистр.Добавить();
				////pas.ВыделенныйСервер = ВС;
				////pas.Параметр = Перечисления.ТипыРесурсов_ат.AdmPass;
				////pas.Значение = ПарольАдмина;

				//
				//// продолжение будет!!!
				//ЗаписьВРегистр.Записать();
				//Изменить = ложь;
				//Элементы.изменить.ТолькоПросмотр = ложь;
				
			//Исключение
			//	Сообщить("Обновление данных на сервере не выполнено");
			//КонецПопытки;
		конецЕсли;
		
		
	Иначе 	
		
	КонецЕсли;
	
	//Настройка(СтрКомНастройка,ИмяФайлаНастройка,ИмяЛогаНастройка);
	
	
	
КонецПроцедуры

//&НаСервере
//Процедура ВыделенныйСервер2ПриИзмененииНаСервере()
//	       	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
//	// Данный фрагмент построен конструктором.
//	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ВыделенныеСерверы_ат.ВыделенныйСервер,
//		|	ВыделенныеСерверы_ат.Параметр,
//		|	ВыделенныеСерверы_ат.Значение
//		|ИЗ
//		|	РегистрСведений.ВыделенныеСерверы_ат КАК ВыделенныеСерверы_ат
//		|ГДЕ
//		|	ВыделенныеСерверы_ат.ВыделенныйСервер = &ВыделенныйСервер";
//	
//	Запрос.УстановитьПараметр("ВыделенныйСервер", ВыделенныйСервер);
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	
//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//		Если ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.Core тогда
//			Если ВыборкаДетальныеЗаписи.Значение = 0 тогда
//				Core = 1; 
//			иначе
//				Core = ВыборкаДетальныеЗаписи.Значение;
//			КонецЕсли;
//		ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.HDD_ат тогда
//			Если ВыборкаДетальныеЗаписи.Значение = 0 тогда
//				HDD = 1; 
//			иначе
//				HDD = ВыборкаДетальныеЗаписи.Значение; 
//			КонецЕсли;
//			
//		ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.RAM тогда
//			Если ВыборкаДетальныеЗаписи.Значение = 0 тогда
//				RAM = 1; 
//			иначе
//				RAM = ВыборкаДетальныеЗаписи.Значение; 
//			КонецЕсли;
//			
//		ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.IPv4 тогда
//			IPv4 = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.mask тогда
//			mask = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.gate тогда
//			gate = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.dns тогда
//			dns = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.dns2 тогда
//			dns2 = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.numproc тогда
//			если ВыборкаДетальныеЗаписи.Значение = 0 тогда 
//				numproc = 60;
//			Иначе 
//				numproc = ВыборкаДетальныеЗаписи.Значение;
//			КонецЕсли;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.AdmPass тогда
//			Password = ВыборкаДетальныеЗаписи.Значение;
//		Иначеесли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.autostart тогда
//			АвтоЗапуск = ВыборкаДетальныеЗаписи.Значение;	
//	    КонецЕсли;	 
//			
//	КонецЦикла;
//	
//	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

//КонецПроцедуры


#КонецОбласти

#Область Создание
&НаКлиенте
Процедура СоздатьСервер(Команда)
	СпрСерер = ПараметрыНовогоСервера();
	Если ТипЗнч(СпрСерер) = Тип("Число") или СпрСерер = Неопределено тогда
		
		Сообщить("!!! операция прервана на этапе создания!");
		
	Иначе
		ответ = Вопрос("Необходимо настроить новый контейнер! Сделать это сейчас?",РежимДиалогаВопрос.ДаНет);
		Если ответ = КодВозвратаДиалога.Да тогда
			
		//ОткрытьЗначение(параметры);
		Элементы.Группа3.ТекущаяСтраница = Элементы.Настройка;
		Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.ГруппаРесурсы;
		Сервер =  СпрСерер;
		
		
		ответ = Вопрос("заполнить данные о настройки из заявки?",РежимДиалогаВопрос.ДаНет);
			Если ответ = КодВозвратаДиалога.Да тогда
				
				Сообщить("здесь должен быть модуль для обработки этой заявки, но пока просто снимем галочку  и откроем заявку =)");
				ОткрытьЗначение(Заявка);
				изменить = истина;
				изменитьПриИзменении();
				
				
				
			КонецЕсли;
		
			
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыделенныйСерверНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	//	ФормаВыбораВС = ПолучитьФорму("Справочник.ВыделенныеСерверы_ат.ФормаВыбора",ПараметрыФормы);
	//	Параметры = 
	
	отбор = Новый Структура;
	отбор.Вставить("ПометкаУдаления", Ложь);
	отбор.Вставить("СозданНаСервере", ложь);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",Истина);
	ПараметрыФормы.Вставить("ЗакрытьПриВыборе", Истина);
	ПараметрыФормы.Вставить("Отбор",отбор);
	//ОткрытьФорму("Справочник.ВыделенныеСерверы_ат.ФормаВыбора",ПараметрыФормы,Элемент);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыНовогоСервера(шаблон = "windows_2008r2_ent-6.1.7600", numproc = 60)
	
	Если  ЗначениеЗаполнено(Заявка) тогда
		Если  ЗначениеЗаполнено(Сервер) тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РесурсыИПараметрыСерверов_ат.Параметр,
			|	МАКСИМУМ(РесурсыИПараметрыСерверов_ат.Значение) КАК Значение
			|ИЗ
			|	РегистрСведений.РесурсыИПараметрыСерверов_ат КАК РесурсыИПараметрыСерверов_ат
			|ГДЕ
			|	РесурсыИПараметрыСерверов_ат.Параметр = &Параметр
			|
			|СГРУППИРОВАТЬ ПО
			|	РесурсыИПараметрыСерверов_ат.Параметр";
			
			Запрос.УстановитьПараметр("Параметр", Перечисления.ТипыРесурсов_ат.VEID);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Если РезультатЗапроса.Пустой() тогда
				Сообщить("не удалось определить последний занятый VEID!");
				//Вопрос("Задать VEID вручную?",РежимДиалогаВопрос.ДаНет);
				//Если КодВозвратаДиалога.Да тогда 
				возврат НЕОПРЕДЕЛЕНО;	
				
			Иначе	
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					СвободныйVeid = ВыборкаДетальныеЗаписи.Значение + 1;
				КонецЦикла;
				Если ЗначениеЗаполнено(Сервер.IPv4) тогда
				
				ИмяФайлаСоздание = Константы.ПутьКТемпVZ_ат.Получить() + "new_" + Сервер.Hostname + "_" + СтрЗаменить(СвободныйVeid,Символы.НПП,"") + ".bat";
				ИмяЛогаСоздание  =  Константы.ПутьКТемпVZ_ат.Получить() + "new_" + Сервер.Hostname + "_" + СтрЗаменить(СвободныйVeid,Символы.НПП,"") + ".rez";
				
				ком 	= " --pkgset " + шаблон + " --hostname "  + Заявка.Hostname;
				Команда = """cmd.exe"" ""/C cls| vzctl create " + СтрЗаменить(СвободныйVeid,Символы.НПП,"") + ком + Символ(34);
				//СтрКомСоздание 	= Константы.ПутьКPSTools_ат.Получить() + "PsExec.exe \\" +  СтрЗаменить(Сервер.IPv4[0].ip.ip, " ","") + " -u " + Сервер.login + " -p " + Сервер.Password + " " + команда;
				
				// запуск (в выключенном контейнере 0 процессов - его использовать нельзя, 
				// но без запуска параметры не поменять
				//КомЗапуска =  """cmd.exe"" ""/C cls| vzctl start " +  СтрЗаменить(СвободныйVeid,Символы.НПП,"");
				//СтрКомЗапуска =  Константы.ПутьКPSTools_ат.Получить() + "PsExec.exe \\" +  СтрЗаменить(Сервер.IPv4[0].ip.ip, " ","") + " -u " + Сервер.login + " -p " + Сервер.Password + " " + КомЗапуска;
				//
				
				
				
				Создание = Ложь;//ВыполнениеСОбработкойОшибок(СтрКомСоздание,ИмяФайлаСоздание,ИмяЛогаСоздание,СвободныйVeid);
				Если Создание = Истина тогда
					//ОткрытыйВС = Сервер.ПолучитьОбъект();
					//ОткрытыйВС.СозданНаСервере = истина;
					//ОткрытыйВС.Записать();
			Сообщить("смена статуса заявки " +Заявка + "на статус В ОБРАБОТКЕ");		
					
				попытка	
					ЗаписьЭлементаСправочникаСерверы = Справочники.Серверы_ат.СоздатьЭлемент();
					ЗаписьЭлементаСправочникаСерверы.Hostname 		= Заявка.Hostname;
					ЗаписьЭлементаСправочникаСерверы.Виртуализация 	= Справочники.ВидыВиртуализацииСерверов_ат.VirtuozzoParallels;
					ЗаписьЭлементаСправочникаСерверы.Родитель		= Сервер;
			//		ЗаписьЭлементаСправочникаСерверы.ОперационнаяСистема = Справочники.ОперационныеСистемы_ат.	
					ЗаписьЭлементаСправочникаСерверы.Наименование 	=   Заявка.Hostname;  // ???? 
					ЗаписьЭлементаСправочникаСерверы.КонтрагентВладелец = Заявка.Клиент;
					ЗаписьЭлементаСправочникаСерверы.Записать();
				Исключение
					Сообщить("не удалось создать объект справочника Серверы");
					возврат -1;					
				КонецПопытки;
				
				
				попытка
					ЗаписьВРСРесурсыИПараметрыСерверов = РегистрыСведений.РесурсыИПараметрыСерверов_ат.СоздатьНаборЗаписей();
					ЗаписьВРСРесурсыИПараметрыСерверов.Отбор.Сервер.Установить(ЗаписьЭлементаСправочникаСерверы.Ссылка);
					
					НаборЗаписей 			= ЗаписьВРСРесурсыИПараметрыСерверов.Добавить();
					НаборЗаписей.Сервер 	=  ЗаписьЭлементаСправочникаСерверы.Ссылка;
					НаборЗаписей.Параметр 	= Перечисления.ТипыРесурсов_ат.VEID;
					НаборЗаписей.Значение 	= СвободныйVeid;
					НаборЗаписей.Период	= ТекущаяДата();
					
					
					ЗаписьВРСРесурсыИПараметрыСерверов.Записать(Истина);
					
				Исключение
					Сообщить("не удалось записать параметры в Регистр Сведений!");
					возврат -2;					
				КонецПопытки;

					
				//ПУДействие("start ",ВС);
				
				Возврат  ЗаписьЭлементаСправочникаСерверы.Ссылка;
				КонецЕсли;
				
			Иначе
				Сообщение = Новый СообщениеПользователю;
				Сообщение.ПутьКДанным = "Сервер";
				Сообщение.Текст =  "У данного сервера не задан IP";
				Сообщение.Сообщить();
				возврат -3;
			КонецЕсли;
			
			КонецЕсли;	
			/////////////////////////////////////////////////////////////////////
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.ПутьКДанным = "Сервер";
			Сообщение.Текст =  "Необходимо выбрать сервер размещения!!!";
			Сообщение.Сообщить();
			возврат -4;

			
		КонецЕсли;
		
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.ПутьКДанным = "Заявка";
		Сообщение.Текст =  "Необходимо выбрать заявку на создание сервера!!!";
		Сообщение.Сообщить();
	КонецЕсли;


	
КонецФункции
&НаСервере
Функция ВыполнениеСОбработкойОшибок(СтрКом,ИмяФайла,ИмяЛога,СвободныйVeid)
	Ошибка="";
	результат = ВыполнитьКоманду(СтрКом,ИмяФайла,ИмяЛога, Ошибка);	
	Если  результат = 0 тогда
		сообщить("Операция с контейнером " +  СтрЗаменить(СвободныйVeid,Символы.НПП,"") + " успешно выполнена!");
		Возврат истина;
		
	ИначеЕсли результат = 1 Тогда
		сообщить("Ошибка выполнения: Предыдущий фаил команд не удален! " + ИмяФайла);
		Возврат  ложь;
	ИначеЕсли результат = 2 Тогда
		сообщить("Ошибка выполнения: Ошибка =  Лог файл не найден!!! " + ИмяЛога);
		Возврат  ложь;
	ИначеЕсли результат = 3 Тогда
		сообщить("Ошибка выполнения: Не получилось удалить лог файл!!! " + ИмяЛога);
		Возврат  ложь;
	ИначеЕсли результат = 4 Тогда
		сообщить("Ошибка выполнения: Не получилось удалить фаил команд!!! "+ ИмяФайла);
		Возврат  ложь;
	ИначеЕсли результат = 5 Тогда
		сообщить("Ошибка выполнения на сервере: " + Ошибка);
		Возврат  ложь;
	//ИначеЕсли результат = 6 Тогда
	//	сообщить("Ошибка выполнения на сервере: команда управления не выполнена!! ");
	//	Возврат  ложь;
	КонецЕсли;
	
	//////////////////////////////////////////////////////////////////////////////		
КонецФункции


&НаСервере
Функция ВыполнитьКоманду(Команда, ИмяФайла, ИмяЛога, Ошибка="")
	
	Файло = Новый Файл(ИмяФайла);
	Если Файло.Существует() тогда
		Возврат 1;
	Иначе
		ФайлоКоманд = Новый ТекстовыйДокумент;
		ФайлоКоманд.ДобавитьСтроку(Команда);
		ФайлоКоманд.Записать(ИмяФайла,"windows-1252");
		//	стр = ИмяФайла + " > " + ИмяЛога;
		стр = ИмяФайла + " " + Символ(КодСимвола(">")) + " " +ИмяЛога + " 2<&1";
		
		Шелл = Новый COMОбъект("WScript.Shell");
		Вывод = Шелл.Run(Стр,,-1);
		
		
		Попытка
			УдалитьФайлы(Константы.ПутьКТемпVZ_ат.Получить(), Файло.Имя);
		Исключение
			Возврат 4;
		КонецПопытки;
		
		ЛогФайл = Новый Файл(ИмяЛога);
		Если ЛогФайл.Существует() тогда
			Лог = Новый ЧтениеТекста(ИмяЛога);
			СыройЛог = лог.Прочитать();
			Лог.Закрыть();
			Попытка
				УдалитьФайлы(Константы.ПутьКТемпVZ_ат.Получить(), ЛогФайл.Имя);
				
				НаборСтрок = РаботаССерверамиСлужебный_ат.РазложитьСтрокуВМассивПодстрок(СыройЛог, Символы.ПС);
				Для каждого стр из НаборСтрок цикл

						Если не Найти(стр, "error code 0") > 0 и Найти(стр, "error") > 0 тогда 
							Ошибка = стр;
							Возврат 5;
						КонецЕсли;


					КонецЦикла;
					Возврат 0;
				Исключение
					Возврат 3;
				КонецПопытки;
			Иначе
				
				Возврат 2;
			КонецЕсли;
		КонецЕсли;
	КонецФункции
	#КонецОбласти
	
	#КонецОбласти
	
	#Область Статистика
	
	&НаКлиенте
	Процедура ЗапросСтатистики(Команда)
		Если ВсеСервера=Истина тогда
			ЗапросСтатистикиДляВсехСерверов()
		Иначе
			
			Если ПустаяСтрока(Сервер) тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Поле = "Сервер";
				Сообщение.Текст = "Необходимо выбрать сервер!";
				Сообщение.Сообщить();
			Иначе
				РаботаССерверами_ат.ОбработкаСтатистики(Сервер);
			КонецЕсли;
		КонецЕсли;
		
	КонецПроцедуры
	
	
	&НаСервере
	процедура ЗапросСтатистикиДляВсехСерверов()
		
		
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
		// Данный фрагмент построен конструктором.
		// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
		Аренда = Истина;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Серверы_ат.Ссылка
		|ИЗ
		|	Справочник.Серверы_ат КАК Серверы_ат
		|ГДЕ
		|	Серверы_ат.Аренда = &Аренда";
		
		Запрос.УстановитьПараметр("Аренда", Аренда);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			РаботаССерверами_ат.ОбработкаСтатистики(ВыборкаДетальныеЗаписи.Ссылка)
			
		КонецЦикла;
		
		//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
		
		
	конецПроцедуры
	
	
	//&НаСервере
	//Процедура Сервер1ПриИзмененииНаСервере()
	//	Если Сервер.Пустая() тогда
	//		Сообщить("необходимо выбрать сервер, который мы будем создавать на сервере");
	//	Иначе
	//		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	//		// Данный фрагмент построен конструктором.
	//		// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	//		
	//		Запрос = Новый Запрос;
	//		Запрос.Текст =
	//		
	//		
	//        "ВЫБРАТЬ
	//        |	РесурсыИПараметрыСерверов_ат.Значение,
	//        |	РесурсыИПараметрыСерверов_ат.Параметр,
	//        |	РесурсыИПараметрыСерверов_ат.Родитель,
	//        |	РесурсыИПараметрыСерверов_ат.Сервер
	//        |ИЗ
	//        |	РегистрСведений.РесурсыИПараметрыСерверов_ат КАК РесурсыИПараметрыСерверов_ат
	//        |ГДЕ
	//        |	РесурсыИПараметрыСерверов_ат.Сервер = &Сервер
	//        |	И РесурсыИПараметрыСерверов_ат.Сервер.ПометкаУдаления = &ПометкаУдаления";
	//		
	//		Запрос.УстановитьПараметр("Сервер", Сервер);
	//		Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);

	//		//"ВЫБРАТЬ
	//		//|	ВыделенныеСерверы_ат.ВыделенныйСервер,
	//		//|	ВыделенныеСерверы_ат.Параметр,
	//		//|	ВыделенныеСерверы_ат.Значение
	//		//|ИЗ
	//		//|	РегистрСведений.ВыделенныеСерверы_ат КАК ВыделенныеСерверы_ат
	//		//|ГДЕ
	//		//|	ВыделенныеСерверы_ат.ВыделенныйСервер = &ВыделенныйСервер";
	//		//
	//		//Запрос.УстановитьПараметр("ВыделенныйСервер", ВыделенныйСервер);
	//		
	//		РезультатЗапроса = Запрос.Выполнить();
	//		
	//		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//		
	//		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//			Если ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.Core тогда
	//				Core = ВыборкаДетальныеЗаписи.Значение; 
	//			ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.HDD_ат тогда
	//				HDD = ВыборкаДетальныеЗаписи.Значение; 
	//			ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.RAM тогда
	//				RAM = ВыборкаДетальныеЗаписи.Значение;
	//				
	//				// перевод МБ в ГБ
	//				
	//				
	//				//		ИначеЕсли ВыборкаДетальныеЗаписи.Параметр = Перечисления.ТипыРесурсов_ат.Core тогда	
	//			КонецЕсли;	
	//			// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//		КонецЦикла;
	//		
	//		//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	//	КонецЕсли;
	//	
	//КонецПроцедуры
	#КонецОбласти
	
	&НаКлиенте
	Процедура СимволПриИзменении(Элемент)
		Код = КодСимвола(Сим);
	КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПроверкаДоступностиЭлементовФормы();
	
	//ДатаИВремя = ТекущаяДата();


	КонецПроцедуры

	&НаКлиенте
	Процедура ЗапросСтатистикиСРеальныхWindowsСерверов(Команда)
		Данные = Неопределено;
		Если ВсеСервера=Истина тогда
			//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			// Данный фрагмент построен конструктором.
			// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
			ЗапросСтатистикиДляВсехСерверовНаСервере();
			
		Иначе
			//Если НЕ Сервер.Пустая() тогда
			РаботаССерверами_ат.ОбрабатываемСтатистикуWMI(Сервер,Данные);
			
			//КонецЕсли;
		КонецЕсли;
		
		
	КонецПроцедуры
&НаСервере
Процедура ЗапросСтатистикиДляВсехСерверовНаСервере();
	
			//Запрос = Новый Запрос;
			//Запрос.Текст = 
			//"ВЫБРАТЬ
			//|	РесурсыИПараметрыСерверов_ат.Сервер,
			//|	РесурсыИПараметрыСерверов_ат.Параметр,
			//|	РесурсыИПараметрыСерверов_ат.Родитель,
			//|	РесурсыИПараметрыСерверов_ат.Значение
			//|ИЗ
			//|	РегистрСведений.РесурсыИПараметрыСерверов_ат КАК РесурсыИПараметрыСерверов_ат
			//|ГДЕ
			//|	РесурсыИПараметрыСерверов_ат.Параметр = &Параметр
			//|	И РесурсыИПараметрыСерверов_ат.Значение = &СборСтатистикиWMI";
			//
			//Запрос.УстановитьПараметр("СборСтатистикиWMI", истина);
			//Запрос.УстановитьПараметр("Параметр", ПредопределенноеЗначение("Перечисление.ТипыРесурсов_ат.СборСтатистикиWMI"));
			//
			//РезультатЗапроса = Запрос.Выполнить();
			//
			//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			//
			//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			//	СерверныеКоманды_ат.ЗапросСтатистикиWMI(ВыборкаДетальныеЗаписи.Сервер) ;
			//КонецЦикла;
			//

			СписокСерверовДляСбораСтатистикиПоWMI	=  РаботаССерверами_ат.ПолучениеСпискаСерверов(Перечисления.ТипыРесурсов_ат.СборСтатистикиWMI);
			Если СписокСерверовДляСбораСтатистикиПоWMI.Количество() > 0 тогда
				РаботаССерверами_ат.ПолучениеСтатистикиWMI_at(СписокСерверовДляСбораСтатистикиПоWMI);	
			КонецЕсли;
 
КонецПроцедуры


&НаКлиенте
Процедура Группа10ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Zabbix тогда
		Элементы.Сервер.Доступность = Ложь;
	Иначе 
		Элементы.Сервер.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
	Процедура СерверНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		Если Элементы.СтраницыСтатистики.ТекущаяСтраница = Элементы.WinServersReal  тогда
			
		КонецЕсли;
		

	КонецПроцедуры

&НаКлиенте
Процедура Сервер1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;	

	ПараметрыОтбора = новый Структура;
	ПараметрыОтбора.Вставить("Виртуализация", ПредопределенноеЗначение("Справочник.ВидыВиртуализацииСерверов_ат.VirtuozzoParallels"));
	
	ПараметрыФормы = новый Структура;
	ПараметрыФормы.Вставить("Отбор",ПараметрыОтбора);

	форма = ПолучитьФорму("Справочник.Серверы_ат.ФормаВыбора",ПараметрыФормы,Элемент);
	Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;	
	форма.открыть();	
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическийСерверНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;		
	//ПараметрыОтбора = новый Структура;
	//ПараметрыОтбора.Вставить("Виртуализация", ПредопределенноеЗначение("Справочник.Виртуаллизация_ат.БезВиртуализации"));
	//ПараметрыОтбора.Вставить("Параметр", ПредопределенноеЗначение("Перечисление.ТипыРесурсов_ат.РазрешенаАренда"));
	//ПараметрыОтбора.Вставить("Значение", истина);
	//ПараметрыОтбора.Вставить("ПометкаУдаления", ложь);
	
	//ПараметрыФормы = новый Структура;
//	ПараметрыФормы.Вставить("ПроизвольныйЗапрос",истина);
//	ПараметрыФормы.Вставить("Отбор",ПараметрыОтбора);

	//ПараметрыФормы.Вставить("Виртуализация", ПредопределенноеЗначение("Справочник.Виртуаллизация_ат.БезВиртуализации"));
	//ПараметрыФормы.Вставить("Параметр", ПредопределенноеЗначение("Перечисление.ТипыРесурсов_ат.РазрешенаАренда"));
	//ПараметрыФормы.Вставить("Значение", истина);
	//ПараметрыФормы.Вставить("ПометкаУдаления", ложь);

	
	форма = ПолучитьФорму("Справочник.Серверы_ат.Форма.ФормаОтбораИВыбора", ,Элемент);
	Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	//ФСначалоВыбораНаСервере(форма.Список);
	
//	Сообщить("теСТ");	

	форма.открыть();
	
КонецПроцедуры


&НаСервере
Процедура ФСначалоВыбораНаСервере(Список)
	
Список.ПроизвольныйЗапрос = истина;
Список.ТекстЗапроса = 
		 " 	ВЫБРАТЬ
		 |	Серверы_ат.Ссылка,
		 |	РесурсыИПараметрыСерверов_ат.Параметр,
		 |	РесурсыИПараметрыСерверов_ат.Значение
		 |ИЗ
		 |	РегистрСведений.РесурсыИПараметрыСерверов_ат КАК РесурсыИПараметрыСерверов_ат
		 |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Серверы_ат КАК Серверы_ат
		 |		ПО РесурсыИПараметрыСерверов_ат.Сервер = Серверы_ат.Ссылка
		 |ГДЕ
		 |	РесурсыИПараметрыСерверов_ат.Сервер.ПометкаУдаления = &ПометкаУдаления
		 |	И РесурсыИПараметрыСерверов_ат.Параметр.Ссылка = &Параметр
		 |	И РесурсыИПараметрыСерверов_ат.Значение = &Значение";
//Список.ТекстЗапроса = 
//		 " 	ВЫБРАТЬ
//		 |	Серверы_ат.Ссылка,
//		 |	РесурсыИПараметрыСерверов_ат.Параметр,
//		 |	РесурсыИПараметрыСерверов_ат.Значение
//		 |ИЗ
//		 |	РегистрСведений.РесурсыИПараметрыСерверов_ат КАК РесурсыИПараметрыСерверов_ат
//		 |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Серверы_ат КАК Серверы_ат
//		 |		ПО РесурсыИПараметрыСерверов_ат.Сервер = Серверы_ат.Ссылка
//		 |ГДЕ
//		 |	РесурсыИПараметрыСерверов_ат.Сервер.ПометкаУдаления = ложь
//		 |	И РесурсыИПараметрыСерверов_ат.Параметр = Перечисление.ТипыРесурсов_ат.РазрешенаАренда
//		 |	И РесурсыИПараметрыСерверов_ат.Значение = Истина";
Список.Параметры.УстановитьЗначениеПараметра("ПометкаУдаления", ложь);
Список.Параметры.УстановитьЗначениеПараметра("Параметр", Перечисления.ТипыРесурсов_ат.РазрешенаАренда);
Список.Параметры.УстановитьЗначениеПараметра("Значение", истина);

		 
Сообщить("теСТ");	

КонецПроцедуры


&НаКлиенте
Процедура Группа3ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Сервер = ПредопределенноеЗначение("Справочник.Серверы_ат.ПустаяСсылка");
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;
	
	ПараметрыОтбора = новый Структура;
//ПараметрыОтбора.Вставить("Статус", ПредопределенноеЗначение("Перечисление.СтатусыЗаявок_ат.Выполняется"));
	ПараметрыОтбора.Вставить("Действие", ПредопределенноеЗначение("Перечисление.ДействияПоЗаявкеНаАрендуОборудования_ат.АрендаНовогоСервера"));
	ПараметрыОтбора.Вставить("ПометкаУдаления", ложь);
	
	
	ПараметрыФормы = новый Структура;
	ПараметрыФормы.Вставить("Отбор",ПараметрыОтбора);
	
	форма = ПолучитьФорму("Документ.ЗаявкаНаАрендуОборудования_ат.ФормаВыбора",ПараметрыФормы,Элемент);
	//Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	
	форма.открыть();

	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаПриИзменении(Элемент)
	ПроверкаДоступностиЭлементовФормы()	
КонецПроцедуры

&НаСервере
Процедура ПроверкаДоступностиЭлементовФормы()
	
	Если ЗначениеЗаполнено(Заявка) тогда
		Элементы.ФизическийСервер.Доступность = истина;
	Иначе
		Элементы.ФизическийСервер.Доступность = ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заявка) и ЗначениеЗаполнено(Сервер) тогда
		Элементы.СОЗДАТЬ.Доступность = истина;
	Иначе
		Элементы.СОЗДАТЬ.Доступность = ложь;
	КонецЕсли;
	
	Если Изменить = ложь тогда
		Элементы.ГруппаСеть.ТолькоПросмотр = истина;
		Элементы.ГруппаРесурсы.ТолькоПросмотр = истина;
		Элементы.ГруппаДоп.ТолькоПросмотр = истина;
	Иначе
		Элементы.ГруппаСеть.ТолькоПросмотр = ложь;
		Элементы.ГруппаРесурсы.ТолькоПросмотр = ложь;
		Элементы.ГруппаДоп.ТолькоПросмотр = ложь;
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ФизическийСерверПриИзменении(Элемент)
	ПроверкаДоступностиЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура Сервер1ПриИзменении(Элемент)
	Сервер1ПриИзмененииНаСервере();
КонецПроцедуры
&НаСервере
Процедура Сервер1ПриИзмененииНаСервере()
	
Сообщить("здесь должна быть процедура/функция ""Сервер1ПриИзмененииНаСервере"" которая подтянет параметры из регистра!");	
	
КонецПроцедуры


&НаКлиенте
Процедура IPTextПриИзменении(Элемент)
	
	IPInt = РаботаССерверамиСлужебный_ат.ПреобразоватьIPВЧисло(IPText);

КонецПроцедуры

&НаКлиенте
Процедура IPIntПриИзменении(Элемент)
	
	IPText = РаботаССерверамиСлужебный_ат.ПреобразоватьЧислоВТекстовыйIP(IPInt);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧислоПриИзменении(Элемент)
	ЧислоПриИзмененииНаСервере()	
КонецПроцедуры

&НаСервере
Процедура ЧислоПриИзмененииНаСервере()
	
	Биты = РаботаССерверамиСлужебный_ат.ПереводимЧислоВБиты(Число);
	
КонецПроцедуры

&НаКлиенте
Процедура IPПриИзменении(Элемент)
	 ПолучаемАдресСети() ;
КонецПроцедуры

&НаКлиенте
Процедура МаскаСетиПриИзменении(Элемент)
	 ПолучаемАдресСети()
КонецПроцедуры

&НаСервере
Процедура ПолучаемАдресСети()
	
	//intIP		= ОбщиеКоманды_ат.ПереводимЧислоВБиты(ОбщиеКоманды_ат.ПреобразоватьIPВЧисло(IP));
	//intMask	= ОбщиеКоманды_ат.ПереводимЧислоВБиты(ОбщиеКоманды_ат.ПреобразоватьIPВЧисло(МаскаСети));
	Если ЗначениеЗаполнено(IP) и ЗначениеЗаполнено(МаскаСети)    тогда
		IntADDR  	= РаботаССерверамиСлужебный_ат._AND(РаботаССерверамиСлужебный_ат.ПреобразоватьIPВЧисло(IP),РаботаССерверамиСлужебный_ат.ПреобразоватьIPВЧисло(МаскаСети),32);
		АдресСети = РаботаССерверамиСлужебный_ат.ПреобразоватьЧислоВТекстовыйIP(IntADDR,".");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИВремяПриИзменении(Элемент)
	ДатаИВремяПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДатаИВремяПриИзмененииНаСервере()
	
	ПересчетUnixTime(ДатаИВремя, ЧасовойПояcЧас, ЧасовойПоясМинуты, ОтрицательноеВремя);

КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.Служебная тогда
		
		ЧасовойПояcЧас = 3;				//Дата(0000,01,01,03,00,00);
		ЧасовойПоясМинуты = 0;
		
		ДатаИВремя = ТекущаяДата()	;

		ЧасовойПояс = ЧасовойПояcЧас*60*60;
		
		UnixTime = РаботаССерверами_ат.UnixTime(ДатаИВремя,,ЧасовойПояс);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтрицательноеВремяПриИзменении(Элемент)
	
	ПересчетUnixTime(ДатаИВремя, ЧасовойПояcЧас, ЧасовойПоясМинуты, ОтрицательноеВремя);


КонецПроцедуры

&НаКлиенте
Процедура ЧасПриИзменении(Элемент)
	
	ПересчетUnixTime(ДатаИВремя, ЧасовойПояcЧас, ЧасовойПоясМинуты, ОтрицательноеВремя);


КонецПроцедуры

&НаКлиенте
Процедура МинутыПриИзменении(Элемент)
	
	ПересчетUnixTime(ДатаИВремя, ЧасовойПояcЧас, ЧасовойПоясМинуты, ОтрицательноеВремя);


КонецПроцедуры

&НаСервере
Процедура ПересчетUnixTime(ДатаИВремя, Часы, минуты, отрицательноеВремя)
	                            
	Если 	отрицательноеВремя тогда
		ЧасовойПояс = (Часы *60*60 + Минуты*60)*(-1); 	
	Иначе
		ЧасовойПояс = Часы *60*60 + Минуты*60;
	КонецЕсли;
	
	 UnixTime = РаботаССерверами_ат.UnixTime(ДатаИВремя,,ЧасовойПояс)	

	
КонецПроцедуры

//&НаСервере
//Процедура ЗапросСтатистикиZabbixНаСервере()
//	    		
//	СерверныеКоманды_ат.ПолучениеСтатистикиЧерезZabbix();
//					
//КонецПроцедуры

&НаСервере
Процедура МассовыйЗапросСтатистикиНаСервере()
		
	РаботаССерверами_ат.ПолучениеСтатистикиZabbix(1) ;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросСтатистикиZabbix(Команда)
	
		   МассовыйЗапросСтатистикиНаСервере();
		
КонецПроцедуры
