#!/bin/bash

echo "🚀 رفع تطبيق Flutter Web على GitHub Pages"
echo "=============================================="
echo ""

# 1. التأكد من حفظ جميع التغييرات
echo "1️⃣ التحقق من حالة Git..."
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  يوجد تغييرات غير محفوظة. يرجى عمل commit أولاً."
    exit 1
fi

# 2. بناء التطبيق
echo ""
echo "2️⃣ بناء التطبيق للويب..."
flutter build web --base-href "/flutter_real_estate_app/"

# 3. حفظ الفرع الحالي
CURRENT_BRANCH=$(git branch --show-current)
echo ""
echo "3️⃣ الفرع الحالي: $CURRENT_BRANCH"

# 4. إنشاء أو التبديل إلى فرع gh-pages
echo ""
echo "4️⃣ التبديل إلى فرع gh-pages..."
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# 5. حذف الملفات القديمة (ما عدا .git و build)
echo ""
echo "5️⃣ تنظيف الفرع..."
git rm -rf . 2>/dev/null || true
git clean -fxd -e build

# 6. نقل ملفات build/web إلى الجذر
echo ""
echo "6️⃣ نقل ملفات الويب..."
cp -r build/web/* .

# 7. حذف مجلد build
rm -rf build

# 8. إضافة ملف .nojekyll (مهم لـ GitHub Pages)
touch .nojekyll

# 9. إضافة الملفات وعمل commit
echo ""
echo "7️⃣ إضافة الملفات إلى Git..."
git add -A
git commit -m "Deploy: Update Flutter web app"

# 10. رفع الفرع
echo ""
echo "8️⃣ رفع الملفات إلى GitHub..."
git push origin gh-pages --force

# 11. العودة للفرع الأساسي
echo ""
echo "9️⃣ العودة للفرع $CURRENT_BRANCH..."
git checkout $CURRENT_BRANCH

echo ""
echo "✅ تم رفع التطبيق بنجاح!"
echo "=============================================="
echo ""
echo "📱 التطبيق متاح على:"
echo "🔗 https://ashrafns.github.io/flutter_real_estate_app/"
echo ""
echo "⚠️ ملاحظة: قد يستغرق الأمر 2-5 دقائق حتى تظهر التحديثات"
echo "=============================================="
