#!/bin/bash

echo "🔧 تحسين أداء المحاكي Android"
echo "======================================"
echo ""

# 1. إغلاق التطبيقات غير المستخدمة
echo "1️⃣ إيقاف التطبيقات الخلفية غير الضرورية..."
adb shell am force-stop com.android.vending
adb shell am force-stop com.google.android.gms
adb shell am force-stop com.google.android.dialer
adb shell am force-stop com.android.phone

# 2. مسح الكاش
echo "2️⃣ مسح الكاش..."
adb shell pm trim-caches 1000M

# 3. تعطيل الأنيميشن (تسريع التطبيق)
echo "3️⃣ تعطيل الأنيميشن للحصول على أداء أفضل..."
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# 4. تفعيل GPU Acceleration
echo "4️⃣ تفعيل GPU Acceleration..."
adb shell setprop debug.hwui.renderer skiagl

echo ""
echo "✅ تم تحسين المحاكي بنجاح!"
echo "======================================"
