# 🌍 Horóscopo e Gerador de Senhas

Um aplicativo Flutter que permite:

* 📌 Consultar horóscopos diários via IA (Gemini API).
* 🔐 Gerar senhas seguras e personalizadas.
* 📂 Salvar e exibir o histórico de consultas e senhas no Firebase Realtime Database.

---

## 🛠️ Funcionalidades

* **Consulta de Horóscopo**:

    * Escolha seu signo e receba o horóscopo do dia gerado por IA.
* **Gerador de Senhas**:

    * Personalize tamanho e tipo de caracteres (maiúsculas, números, símbolos).
    * Copie a senha com um clique.
* **Histórico**:

    * Exibe os horóscopos consultados.
    * Lista as senhas geradas.

---

## 🚀 Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) 3.22+
* [Firebase Realtime Database](https://firebase.google.com/products/realtime-database)
* [Google Gemini API](https://ai.google.dev/)
* [Firebase Core](https://pub.dev/packages/firebase_core)
* [Firebase Database](https://pub.dev/packages/firebase_database)
* [HTTP](https://pub.dev/packages/http)

---

## 📦 Instalação

Clone o repositório:

```bash
git clone https://github.com/seuusuario/horoscopo_e_gerador_de_senhas.git
```

Entre na pasta do projeto:

```bash
cd horoscopo_e_gerador_de_senhas
```

Instale as dependências:

```bash
flutter pub get
```

Configure o Firebase:

```bash
flutterfire configure
```

Rode o aplicativo:

```bash
flutter run
```

---

## 📑 Estrutura do Projeto

```
lib/
├── main.dart
├── pages/
│   ├── home_page.dart
│   ├── horoscope_page.dart
│   └── password_generator_page.dart
├── services/
│   ├── horoscope_service.dart
│   └── firebase_service.dart
└── utils/
    └── password_generator.dart
```

---

## 📊 Regras de Segurança do Firebase

Durante o desenvolvimento, use as seguintes regras para o Realtime Database:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

🚨 **Atenção:** Para produção, atualize para regras mais seguras, como:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

---

## 🌐 Links Importantes

* [Documentação Flutter](https://docs.flutter.dev/)
* [Console Firebase](https://console.firebase.google.com/)
* [Google AI Gemini](https://ai.google.dev/)

---


