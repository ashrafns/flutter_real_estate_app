#!/bin/bash

echo "🚀 رفع تطبيق Flutter Web على GitHub Pages"
echo "=============================================="
echo ""

# 1. بناء التطبيق
echo "1️⃣ بناء التطبيق للويب..."
flutter build web --base-href "/flutter_real_estate_app/"

# 2. إنشاء فرع gh-pages
echo ""
echo "2️⃣ إنشاء فرع gh-pages..."
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# 3. حذف الملفات القديمة (ما عدا build)
echo ""
echo "3️⃣ تحضير الملفات..."
find . -maxdepth 1 ! -name '.git' ! -name 'build' ! -name '.' ! -name '..' -exec rm -rf {} +

# 4. نقل ملفات build/web إلى الجذر
echo ""
echo "4️⃣ نقل ملفات الويب..."
cp -r build/web/* .

# 5. حذف مجلد build
rm -rf build

# 6. إضافة ملف .nojekyll (مهم لـ GitHub Pages)
touch .nojekyll

# 7. إضافة الملفات وعمل commit
echo ""
echo "5️⃣ إضافة الملفات إلى Git..."
git add .
git commit -m "Update: Fixed scroll behavior in home screen"

# 8. رفع الفرع
echo ""
echo "6️⃣ رفع الملفات إلى GitHub..."
git push origin gh-pages --force

# 9. العودة للفرع الأساسي
echo ""
echo "7️⃣ العودة للفرع main..."
git checkout main

echo ""
echo "✅ تم رفع التطبيق بنجاح!"
echo "=============================================="
echo ""
echo "📱 التطبيق متاح على:"
echo "🔗 https://ashrafns.github.io/flutter_real_estate_app/"
echo ""
echo "⚠️ ملاحظة: قد يستغرق الأمر 2-5 دقائق حتى تظهر التحديثات"
echo "=============================================="
