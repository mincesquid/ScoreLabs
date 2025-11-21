# Contributing to ScoreLabs

Thank you for your interest in contributing to ScoreLabs! This document provides guidelines and standards for contributing to the project.

## 🌟 Ways to Contribute

- **Bug Reports**: Submit detailed bug reports with reproduction steps
- **Feature Requests**: Propose new features or improvements
- **Code Contributions**: Submit patches, new tools, or improvements
- **Documentation**: Improve or add documentation
- **Lab Scenarios**: Create new sandbox scenarios and exercises
- **Tool Integration**: Add or improve security tool configurations
- **Testing**: Test builds and provide feedback

## 🚀 Getting Started

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/scorelabs.git
   cd scorelabs
   ```

2. **Configure Git (Important!)**
   
   Run the setup script to ensure proper git configuration:
   ```bash
   ./scripts/setup-git.sh
   ```
   
   This allows you to see and merge changes from all branches, including OS assets and feature branches.
   
   See [Git Workflow FAQ](docs/git-workflow-faq.md) for common git scenarios and solutions.

3. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Your Changes**
   - Follow the coding standards below
   - Test your changes thoroughly
   - Update documentation as needed

5. **Submit a Pull Request**
   - Provide a clear description of changes
   - Reference any related issues
   - Ensure all tests pass

## 📋 Coding Standards

### Shell Scripts
- Use `#!/bin/bash` or `#!/usr/bin/env bash`
- Include error handling with `set -e`
- Add comments for complex operations
- Follow [ShellCheck](https://www.shellcheck.net/) recommendations

### Python Code
- Follow PEP 8 style guidelines
- Use type hints where appropriate
- Include docstrings for functions and classes
- Write unit tests for new functionality

### Configuration Files
- Use consistent indentation (2 or 4 spaces)
- Add comments explaining non-obvious settings
- Validate syntax before committing

## 🧪 Creating Lab Scenarios

Lab scenarios should be:
- **Educational**: Clear learning objectives
- **Safe**: Properly isolated and contained
- **Realistic**: Based on real-world scenarios
- **Documented**: Include setup, objectives, and solutions

### Lab Scenario Template

```
labs/scenarios/scenario-name/
├── README.md           # Scenario description and objectives
├── setup.sh           # Setup script
├── scenario.yml       # Configuration
├── hints/             # Progressive hints
└── solution/          # Solution guide
```

## 🛠️ Tool Integration Guidelines

When adding a new security tool:

1. **Package Definition**: Create PKGBUILD in `packages/`
2. **Configuration**: Add default configs in `config/tools/`
3. **Documentation**: Document usage in `docs/tools.md`
4. **Testing**: Verify tool works in the ScoreLabs environment
5. **Suite Assignment**: Add to appropriate tool suite (forensics, pentesting, etc.)

## 📝 Documentation Standards

- Use Markdown for all documentation
- Include code examples where applicable
- Keep language clear and concise
- Add screenshots for UI-related features
- Update table of contents when adding sections

## 🔍 Testing

Before submitting:

1. **Build Test**: Ensure the ISO builds successfully
   ```bash
   ./build.sh --test
   ```

2. **VM Test**: Test in a virtual machine
   ```bash
   ./scripts/test-vm.sh
   ```

3. **Tool Test**: Verify your changes don't break existing tools
   ```bash
   ./scripts/test-tools.sh
   ```

## 🐛 Bug Reports

Good bug reports include:

- **Description**: Clear description of the issue
- **Steps to Reproduce**: Detailed reproduction steps
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**: ScoreLabs version, kernel version, hardware
- **Logs**: Relevant log files or error messages

## 💡 Feature Requests

Feature requests should include:

- **Use Case**: Why this feature is needed
- **Proposed Solution**: How you envision it working
- **Alternatives**: Other approaches considered
- **Implementation Ideas**: Technical approach (if applicable)

## 🔐 Security Issues

**Do not** open public issues for security vulnerabilities.

Instead, email security concerns to: security@scorelabs.org

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different perspectives and experiences
- Prioritize the community's well-being

## ⚖️ Legal Considerations

By contributing, you agree that:

- Your contributions will be licensed under the MIT License
- You have the right to submit the contribution
- Your contributions comply with all applicable laws
- You understand the ethical implications of security tools

## 📞 Getting Help

- **Git Issues**: See [Git Workflow FAQ](docs/git-workflow-faq.md) and [Git Troubleshooting](docs/git-troubleshooting.md)
- **Documentation**: Check the docs/ directory
- **Discussions**: Join GitHub Discussions
- **Chat**: Join our community chat (link in README)
- **Issues**: Search existing issues before creating new ones

## 🎯 Priority Areas

Current priority contribution areas:

- [ ] Expanding lab scenario library
- [ ] Improving sandbox isolation
- [ ] Adding more forensics tools
- [ ] Documentation improvements
- [ ] Automated testing framework
- [ ] Performance optimizations

Thank you for contributing to ScoreLabs! Together, we're building a powerful platform for security education and research.
