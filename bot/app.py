import asyncio
import logging
from os import getenv

from aiogram import Bot, Dispatcher, Router, types
from aiogram.filters import Command

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(name)s - %(message)s",
)

BOT = Bot(token=getenv('BOT_TOKEN'))
router = Router()


async def set_commands(bot: Bot) -> None:
    commands = [
        types.BotCommand(command="/help", description="Display help message"),
    ]
    await bot.set_my_commands(commands)


async def del_message(message: types.Message, daley: float = 0) -> None:
    await asyncio.sleep(daley)
    await message.delete()


@router.message(Command(commands=["help"]))
async def help_command(message: types.Message) -> None:
    await del_message(message)
    await message.answer('This is a cbt logging bot\n',
                         disable_notification=True,
                         parse_mode="html")


async def main() -> None:
    dp = Dispatcher()
    dp.include_router(router)

    try:
        await set_commands(BOT)
        await BOT.delete_webhook(drop_pending_updates=True)
        await dp.start_polling(BOT)
    finally:
        await dp.storage.close()
        await BOT.session.close()


if __name__ == '__main__':
    asyncio.run(main())
