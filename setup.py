from setuptools import find_packages, setup

with open('requirements.txt') as f:
    required = f.read().splitlines()

setup(
    name='cbt_bot',
    version='1.0.24',
    description='Когнитивно-поведенческая терапия, или КБТ, - это вид психотерапии, который помогает людям выявить и '
                'изменить негативные мыслительные процессы и поведение.',
    author='@pasha_os',
    url='https://github.com/Seal-Pavel/cbt_bot',
    packages=find_packages(),
    install_requires=required,
)
