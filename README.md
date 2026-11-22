# متجر IT Tools — تطبيق الزبائن (Flutter)

تطبيق تجارة إلكترونية متخصص ببيع ملحقات الحاسوب للأفراد والطلاب في سوريا، مبني باستخدام إطار العمل **Flutter** بتصميم عربي متكامل من اليمين إلى اليسار (**RTL**).

---

## 1. المتطلبات الأساسية (Prerequisites)

* **Flutter SDK:** الإصدار `3.24.0` أو أحدث (متوافق مع Dart `3.5.0+`).
* **بيئات التشغيل المدعومة:** Android (API 24 / Android 7.0 فأحدث) و iOS (iOS 13 فأحدث).
* **محرر الكود المقترح:** VS Code مع إضافتي Flutter و Dart.

---

## 2. خطوات التثبيت والتشغيل (Setup & Running)

1. **استنساخ المستودع (Clone):**
   ```bash
   git clone https://github.com
   cd it_tools_app
   ```

2. **تثبيت الحزم والاعتماديات:**
   ```bash
   flutter pub get
   ```

3. **تشغيل التطبيق حسب البيئة (dev / prod):**
   * **بيئة التطوير (Development):**
     ```bash
     flutter run --dart-define-from-file=config/dev.json
     ```
   * **بيئة الإنتاج (Production):**
     ```bash
     flutter run --dart-define-from-file=config/prod.json
     ```
   *(يمكن أيضاً التشغيل مباشرة من قائمة **Run and Debug** في VS Code باختيار `IT Tools (Dev)` أو `IT Tools (Prod)`).*

---

## 3. أوامر توليد الكود والفحص (Code Generation & Linting)

* **توليد الملفات التلقائية (`build_runner`) عند تعديل النماذج أو الحزم:**
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
* **فحص جودة الكود والتأكد من الالتزام بقواعد الـ Linter:**
  ```bash
  flutter analyze
  ```

---

## 4. هيكل المجلدات وطبقات Clean Architecture

يعتمد المشروع على معمارية **Clean Architecture** مقسمة حسب الميزات (**Feature-first**) لضمان فصل المسؤوليات وسهولة التوسع:

| المسار (`lib/`) | الطبقة / الدور | المسؤولية |
| :--- | :--- | :--- |
| `app/` | تهيئة التطبيق (`App`) | نقطة البداية العامة للتطبيق، إعدادات التوجيه (`Router`)، والتهيئة الأساسية. |
| `core/` | النواة المشتركة (`Core`) | الإعدادات (`config`)، الثوابت (`constants`)، حقن التبعيات (`di`)، البيئات (`environments`)، الثيم (`theme`)، والويدجت المشتركة (`widgets`). |
| `features/<feature>/domain/` | طبقة منطق الأعمال (`Domain`) | الكيانات الأساسية (`Entities`)، عقود المستودعات (`Repositories`)، وحالات الاستخدام (`Use Cases`). |
| `features/<feature>/data/` | طبقة البيانات (`Data`) | مصادر البيانات (`Datasources`)، النماذج (`Models`)، وتنفيذ المستودعات (`Repositories Impl`). |
| `features/<feature>/presentation/` | طبقة العرض (`Presentation`) | الشاشات (`Pages`)، العناصر البصرية (`Widgets`)، وإدارة الحالة (`Cubit`). |

---

## 5. قواعد العمل مع الفروع والـ Commits (Git Workflow)

للحفاظ على نظافة سجل المشروع وتجنب التعارضات بين أعضاء الفريق:

* **إنشاء الفروع:** يُنشأ لكل مهمة فرع مستقل من `main` حسب نوع المهمة:
  * `feat/<feature-name>`: لإضافة ميزة أو شاشة جديدة (مثال: `feat/home-ui`).
  * `fix/<bug-name>`: لإصلاح خطأ برمجي.
  * `chore/<task-name>`: لمهام الإعداد والتهيئة (مثال: `chore/env-config`).
  * `docs/<doc-name>`: لمهام التوثيق (مثال: `docs/readme`).
* **صيغة رسائل الحفظ (`Conventional Commits`):**
  * `feat(scope): وصف الميزة الجديدة`
  * `fix(scope): وصف الإصلاح`
  * `chore(scope): وصف التهيئة`
  * `docs(scope): وصف التوثيق`
* **رفع العمل:** بعد الانتهاء، يُرفع الفرع ويُفتح **Pull Request** نحو `main` للمراجعة والدمج.

---

## 6. وثائق المشروع المرجعية

* [ملخص قواعد العمل الأساسية (Business Rules)](docs/BUSINESS_RULES.md)
