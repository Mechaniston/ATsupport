﻿
//Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
//    
//    СтандартнаяОбработка = Ложь;
//    
//	//Представление = Строка(Данные.Ссылка.Наименование)  + ?(ЗначениеЗаполнено(Данные.Ссылка.DNSсуффикс), "." + Данные.Ссылка.DNSсуффикс, "");
//     Представление = Строка(Данные.Ссылка.Наименование)  
//	 + ?((ЗначениеЗаполнено(Данные.Ссылка.DNS_Suffix) и ЗначениеЗаполнено(Данные.Ссылка.DNS_Suffix[0].suffix)), "." + Данные.Ссылка.DNS_Suffix[0].suffix, " - ");

//КонецПроцедуры



//Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
//    
//	//СтандартнаяОбработка = Ложь;
//	//// Представление = Строка(Данные.Ссылка.Наименование)  + "  ("  + Данные.Ссылка.Hostname +

//	// //Представление = "("  + Данные.Ссылка.Hostname +
//	// //?((ЗначениеЗаполнено(Данные.Ссылка.DNS_Suffix) и ЗначениеЗаполнено(Данные.Ссылка.DNS_Suffix[0].suffix)),  
//	// //( "." + Данные.Ссылка.DNS_Suffix[0].suffix), "") + ")" +?((ЗначениеЗаполнено(Данные.Ссылка.IPv4) и ЗначениеЗаполнено(Данные.Ссылка.IPv4[0].IP)), " (" +
//	// //СтрЗаменить(Данные.Ссылка.IPv4[0].IP.IP," ","") + ")", "");

//	// Представление = "("  + Данные.Ссылка.Hostname 
//	// + ")" +?((ЗначениеЗаполнено(Данные.Ссылка.ОсновнойIP)), Данные.Ссылка.ОсновнойIP, "");	
//	//
//	
//КонецПроцедуры
 
 

 