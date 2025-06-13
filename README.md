# 🎵 GitBey Workshop: AI-Powered GitHub Commit Sentiment Analyzer

> **Transform your GitHub commits into Beyoncé playlists using Flutter and AI!**

Welcome to the GitBey Workshop! Learn to build a complete Flutter application that analyzes your GitHub commit history, determines your coding mood, and creates personalized Beyoncé playlists. This **intensive 3-hour workshop** teaches **agentic development** - using AI assistants to accelerate your development workflow and build production-ready apps quickly.

## 🚀 What You'll Build

**GitBey** is a Flutter app that:
- 📊 Fetches your last 50 GitHub commits via REST API
- 🧠 Analyzes commit sentiment
- 🎶 Generates personalized Beyoncé playlists using GitHub Models API
- 🎵 Provides audio playback with beautiful Flutter UI
- 🎨 Features modern Material Design with smooth animations

## 🎯 Learning Outcomes

By the end of this workshop, you'll understand:

### 🔧 Technical Skills
- **Flutter Development**: Cross-platform mobile app development
- **API Integration**: GitHub REST API and AI services
- **Sentiment Analysis**: Local algorithms and AI-powered analysis
- **Audio Integration**: Spotify API and audio playback
- **Modern UI/UX**: Material Design, animations, responsive layouts

### 🤖 Agentic Development
- **AI-Assisted Coding**: Effective prompting techniques with AI assistants
- **Iterative Development**: Breaking complex features into AI-manageable tasks
- **Code Generation**: Using AI for boilerplate, testing, and documentation
- **Debugging with AI**: Leveraging AI for troubleshooting and optimization

### 🏗️ Architecture Patterns
- **Clean Architecture**: Service layers and separation of concerns
- **Error Handling**: Robust network and API error management
- **Security**: Secure API token management

## 📋 Prerequisites

Before starting, make sure you have:

- [ ] **Flutter SDK** installed ([Installation Guide](https://docs.flutter.dev/get-started/install))
- [ ] **Dart** (comes with Flutter)
- [ ] **Git** for version control
- [ ] **iOS Simulator** [set up](https://developer.apple.com/documentation/xcode/downloading-and-installing-additional-xcode-components)
- [ ] **VS Code** or preferred IDE with Flutter extensions
- [ ] **AI Assistant** (GitHub Copilot - sign up for FREE!)
- [ ] **GitHub Account** with access to your public commits
- [ ] **Willingness to learn** with AI assistance - perfect for beginners!

### 🔑 API Keys Required
- [ ] **GitHub Models API** token (your GitHub PAT)
- [ ] **Spotify Developer** credentials (optional, for future extensions)
- [ ] **GitHub Personal Access Token** for commit, repo, models, issues access ([Guide](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token))
- [ ] **Perplexity API Key** for AI Research ([Sign Up](https://docs.perplexity.ai/guides/getting-started))

### MCP Servers 

- [ ] **Perplexity MCP Server** - For AI research and analysis ([Setup Guide](https://github.com/jsonallen/perplexity-mcp))
- [ ] **GitHub MCP Server** - For interacting with GitHub ([Setup Guide](https://github.com/github/github-mcp-server))
- [ ] **Setup Instructions for MCP Servers in VSCode** - [docs](https://code.visualstudio.com/docs/copilot/chat/mcp-servers).


## 🤝 Contributing

This workshop is open source and community-driven:

- 🐛 **Report bugs** or suggest improvements
- 📝 **Improve documentation** 
- 🎨 **Add workshop materials** (slides, examples, tests)
- 🌍 **Translate** to other languages
- 💡 **Share extension ideas**

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This workshop is licensed under [MIT License](LICENSE) - feel free to use it for your own workshops, courses, or learning!

## 🙏 Acknowledgments

- **Beyoncé** - For the amazing music that inspires our playlists 👑
- **Flutter Team** - For the incredible cross-platform framework
- **GitHub** - For the robust API and Models platform
- **Workshop Contributors** - Everyone who helped make this possible


# Upddates from a dev's perspective

## Some Notes

- Use the workshop instructions if starting over from scratch
- I do not have an apple developer account nor do I have a spotify premium account so it isn't deployed anywhere & the buttons don't work in the demo. But, they _should_ have worked if I had a premium account token
- There was not a ton of perplexity use in the project. I wouldn't pay for a token for this much, maybe use a free alternative if one exists.
- I'd never used Dart or flutter before the presentation. It is a pretty ergonomic experience to be writing to multiple targets at one time. 
- I think the agent functioned moderately well with light guidance
- Building the web target in flutter requires either having google chrome, or running `flutter run -d web-server` separately from the other build
- Simulator must be running for flutter to connect to the ios target

## Further research
 - I would investigate a design pattern that makes the frontend design come out less horrible
 - Determine how to get tests working