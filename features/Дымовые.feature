
#language: ru

@tree

Функциональность: Дымовые тесты меню подсистемы VBM

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Открытие формы списка "ВМ_Модели" 

	Дано Я открываю основную форму списка справочника "ВМ_Модели"
	Если появилось предупреждение тогда
		Тогда я вызываю исключение "Не удалось открыть форму справочника ВМ_Модели"
	И Я закрываю текущее окно
