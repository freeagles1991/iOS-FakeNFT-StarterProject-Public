Неровный Дмитрий Сергеевич\
<b>Когорта:</b> 18\
<b>Группа:</b> 4\
<b>Эпик:</b> Корзина\
<b>[Ссылка на доску](https://github.com/users/freeagles1991/projects/1/views/1?filterQuery=к1)</b>

# Декомпозиция эпика Корзина

## Модуль 1:

### 1. Основной экран корзины (+состояние пустой корзины)
<b>Классы:</b>
- CartStore
- CartViewController
- CartPresenter
- CartCell

<b>Верстка:</b>
- Добавляем NavigationBar - (est: 30 мин; fact: 30 мин)
- Верстка ячейки UICollectionViewCell - (est: 2 часа; fact: 3 часа)
- Верстка CollectionView на экране - (est: 1 час мин; fact: 1 час)
- Верстка пустого состояния - (est: 30 мин; fact: 1 час)
- Верстка кнопки покупки UIButton и UILabel с ценой  - (est: 1 час; fact: 1 час)

<b>Логика:</b>
- Пишем сервис для хранения товаров в корзине - (est: 30 мин; fact: 30 мин)
- Переключение пустой корзины и с товарами - (est: 30 мин; fact: 30 мин)
- Заполнение ячеек данными из сервиса NFTService - (est: 1 час; fact: 3 часа)
- Выделение логики экрана в Presenter - (est: 2 часа; fact: 2 часа)
- Обработка удаления товара из корзины - (est: 1 час; fact: 2 часа)
- Обработка кнопки покупки - (est: 30 мин; fact: 10 мин)
- Обработка кнопки выбора фильтра - (est: 30 мин; fact: 10 мин)

## Модуль 2:

### 2. Экран выбора способа оплаты
<b>Классы:</b>
- CurrencyStorage (где храним все способы оплаты)
- CurrencyService
- ChooseCurrencyViewController
- ChooseCurrencyPresenter

<b>Верстка:</b>
- Верстаем ячейка UICollectionViewCell и сам CollectionView - (est: 3 часа; fact: 3 часа)
- Кнопка покупки и лейбл со ссылкой - (est: 1 час; fact: 2 часа)
- Заголовок в NavigatorBar - (est: 30 мин; fact: 10 мин)

<b>Логика:</b>
- Пишем модель и сервис для хранения способов оплаты - (est: 3 часа; fact: 3 часа)
- Реализуем заполнение ячеек коллекции данными - (est: 2 часа; fact: 1 час)
- Выделение логики экрана в Presenter - (est: 2 часа; fact: 2 часа)
- Обработка выбора способа оплаты - (est: 1 час; fact: 2 часа)
- Обработка кнопки подтверждения - (est: 30 мин; fact: 3 часа)
- Обработка кнопки возврата на предыдущий экран - (est: 30 мин; 30 мин)

## Module 3:

### 3. Экран выбора фильтрации

<b>Классы:</b>
- FilterSelectionViewController
- FilterSelectionPresenter

<b>Верстка:</b>
- Верстка ячейки таблицы UITableViewCell и сама таблица UITableView со списокм фильтров - (est: 2 часа; fact: - часов)
- Верстка кнопки отмены - (est: 30 мин; fact: - часов)

<b> Логика:</b>
- Обработка выбора фильтра - (est: 30 мин; fact: - часов)
- Реализация методов фильтрации, 3 метода - (est: 4 часа; fact: - часов)
- Выделение логики экрана в Presenter (est: 1 час; fact: - часов)
- Обработка кнопки отмены - (est: 30 мин; fact: - часов)

### 4. Экран удаления товара из корзины
<b>Классы:</b>
- RemoveFromCartViewController
- RemoveFromCartPresenter

<b>Верстка:</b>
- Верстка экрана (картинка, лейбл, кнопки, замыливание фона) - (est: 2 часа; fact: - часов)

<b>Логика:</b>
- Заполнение UIImageView выбранным товаром - (est: 1 час; fact: - часов)
- Выделение логики экрана в Presenter - (est: 1 час; fact: - часов)
- Обработка кнопки подтверждения - (est: 30 мин; fact: - часов)
- Обработка кнопки отмены - (est: 30 мин; fact: - часов)

### 5. Экран успешной покупки
<b>Классы:</b>
- PurchaseSuccessViewController
- PurchaseSuccessPresenter

<b>Верстка:</b>
- К3:Покупка - Верстка.Верстка всего экран - (est: 1 час; fact: - часов)

<b>Логика:</b>
- Логика покупки: удаление из корзины и добавление в аккаунт пользователя - (est: 1 час; fact: - часов)
- Обработка возврата в каталог - (est: 30 мин; fact: - часов)
- Выделение логики экрана в Presenter (est: 1 час; fact: - часов)
