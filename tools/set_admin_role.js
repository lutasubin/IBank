/**
 * Script gán custom claim role=admin cho một email Firebase Auth.
 *
 * Cách dùng:
 *   1) Tải service account JSON từ Firebase Console (Project settings -> Service accounts)
 *   2) Đặt biến môi trường:
 *        export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"
 *   3) Cài dependency:
 *        npm install firebase-admin
 *   4) Chạy:
 *        node tools/set_admin_role.js admin@demo.com
 */
const admin = require('firebase-admin');

async function main() {
  const email = process.argv[2];
  if (!email) {
    console.error('Usage: node tools/set_admin_role.js <email>');
    process.exit(1);
  }

  // Yêu cầu đã set GOOGLE_APPLICATION_CREDENTIALS
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, { role: 'admin' });
    const updated = await admin.auth().getUser(user.uid);
    console.log(`Done. Claims for ${email}:`, updated.customClaims);
  } catch (e) {
    console.error('Failed:', e.message);
    process.exit(1);
  }
}

main();

