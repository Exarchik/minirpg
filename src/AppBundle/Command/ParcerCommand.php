<?php

// src/AppBundle/Command/GreetCommand.php
namespace AppBundle\Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

use ZFI\ExusParcer;

class ParcerCommand extends ContainerAwareCommand
{
    protected function configure()
    {
        $this
            ->setName('parcer:run')
            ->setDescription('Parce Your Hotline ua')
            ->addArgument(
                'name',
                InputArgument::OPTIONAL,
                'Who do you want to greet?'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $name = $input->getArgument('name');

        $parcer = new ExusParcer();
        $result = $parcer->execute();

        $text = "PARCER RESULT: ".$result;

        $output->writeln($text);
    }
}